# frozen_string_literal: true

require 'curb'
require 'nokogiri'
require 'csv'

require_relative 'scraper_utils'
require_relative 'scraper_csv_utils'

##
# Main class for scrapping https://www.coldwellbankerhomes.com.
#
# For any state or states must be total scraped 20 000 or more products.
#
# Author::    Alexander Petrov mailto:alex.petrofan@gmail.com
# Link::      https://www.linkedin.com/in/alex-petrov/
class Scraper
  include ScraperUtils
  include ScraperCsvUtils

  def call
    output_start_message
    scrape_data
    output_finish_message
  end

  private

  def initialize
    @products_data = []
  end

  def output_start_message
    $stdout.puts '== Scraping started... =='
  end

  def output_finish_message
    $stdout.puts '== Scraping finished =='
  end

  # NOTE: Now its scrap all states, 1 region, 1 page of products from region,
  # 24 products info
  #
  # TODO: Single thread scraping.
  # scrape_states.each do |state|
  #   scrape_regions(state).each do |region|
  #     scrape_region_products(state, region).each do |product|
  #       @products_data << scrape_product(product)
  #     end
  #   end
  # end
  # export_to_csv('name', @products_data)
  def scrape_data
    state  = scrape_states&.first
    region = scrape_regions(state)[1]

    # Scrape 1 product info.
    # products = scrape_region_products(state, region)
    # scrape_product(products.first)

    # Scrape 1 page (24) products info for 1 region.

    scrape_region_products(state, region).each do |product|
      @products_data << scrape_product(product)
    end

    export_to_csv("4_#{state[:name]}_#{region[:name]}_products", @products_data)
  end

  def scrape_states
    states = scrape_links_page('states', STATES_LIST_URL, 'table.table-sort a')

    export_to_csv('1_states', states)

    states
  end

  def scrape_regions(state)
    regions = scrape_links_page("state `#{state[:name]}`", state[:url],
                                'table.table-sort a')

    export_to_csv("2_#{state[:name]}_regions", regions)

    regions
  end

  # TODO: Refactor to fix RuboCop `Metrics/MethodLength` offense.
  def scrape_region_products(state, region)
    products = scrape_links_page("region `#{region[:name]}`", region[:url],
                                 'div#searchList div.prop-info div.address a',
                                 '.street-address')

    export_to_csv("3_#{state[:name]}_#{region[:name]}_products", products)

    products
  end

  def scrape_product_photos(product_page_html, selector)
    product_page_html.css(selector).map { |image| image['data-href'] }
  end

  # TODO: Refactor to fix RuboCop Metrics/AbcSize/MethodLength offenses.
  def scrape_product(product)
    $stdout.puts "  -- Scraping product `#{product[:name]}` -> "\
      "#{product[:url]} --"

    page_html = get_page_html(product[:url])
    return unless page_html

    product_data_node = page_html
                            .at_css('div[itemtype="http://schema.org/Product"]')
    residence_data_node = page_html
                              .at_css('div[itemtype="http://schema.org/residence"]')

    {
        name: residence_data_node&.at_css('span[itemprop="name"]')&.content,
        url: product[:url],
        address: residence_data_node&.at_css('span[itemprop="streetAddress"]')
                     &.content,
        price_currency:
            product_data_node.at_css('meta[itemprop="priceCurrency"]')[:content],
        price: product_data_node.at_css('span[itemprop="price"]')[:content],
        state: residence_data_node&.at_css('span[itemprop="addressRegion"]')
                   &.content,
        city: residence_data_node&.at_css('span[itemprop="addressLocality"]')
                  &.content,
        postal_zip_code:
            residence_data_node&.at_css('span[itemprop="postalCode"]')&.content,
        bathrooms:
            page_html.css('h4.subhead-meta + ul li')[0].content.gsub(/\D/, ''),
        bedrooms:
            page_html.css('h4.subhead-meta + ul li')[1].content.gsub(/\D/, ''),
        # FIXME: For some products `year_built` scraped empty string.
        year_built: page_html.css('div.col h3.subhead + ul')[9].css('li').last
                        .content.gsub(/\D/, ''),
        photos: scrape_product_photos(page_html,
                                      'section.content div.fancybox-small')
    }
  end
end
