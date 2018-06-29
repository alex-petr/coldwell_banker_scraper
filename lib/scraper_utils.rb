# frozen_string_literal: true

###
# Utility methods.
module ScraperUtils
  BASE_URL = 'https://www.coldwellbankerhomes.com'
  STATES_LIST_URL = "#{BASE_URL}/sitemap/real-estate/"

  module_function

  def get_page_html(url)
    Nokogiri::HTML(Curl.get(url).body_str)
  rescue StandardError => error
    @logger.error "  -- Error during getting page HTML: #{error.inspect} --"
  end

  def scrape_links_page(name, url, selector, name_selector = nil)
    @logger.info "== Scraping #{name} page =="

    # Performance note: condition inside loop is bad, but for this case its ok
    links = get_page_html(url)&.css(selector)&.map do |link_node|
      link_name_node = link_node
      link_name_node = link_node.at_css(name_selector) if name_selector

      { name: link_name_node.content.gsub(/[[:space:]]/, ' ').strip,
        url: BASE_URL + link_node[:href] }
    end

    print_name_link(links)
    export_to_csv(name, links)

    links
  end

  def scrape_product_photos(product_page_html, selector)
    product_page_html.css(selector).map { |image| image['data-href'] }
  end

  private

  def print_name_link(name_links)
    @logger.info "  -- Scraped total #{name_links.count} links --"
    name_links.each do |name_link|
      @logger.info "  #{name_link[:name].ljust(32)} -> #{name_link[:url]}"
    end
  end
end
