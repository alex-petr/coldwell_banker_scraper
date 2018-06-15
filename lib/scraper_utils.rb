# frozen_string_literal: true

###
# Utility methods.
module ScraperUtils
  BASE_URL = 'https://www.coldwellbankerhomes.com'

  module_function

  def get_page_html(url)
    get_response = Curl.get(url)
    Nokogiri::HTML(get_response.body_str)
  rescue StandardError => error
    warn '  -- Error during getting page HTML --'
    warn error.inspect
  end

  def scrape_links_page(name, url, selector, name_selector = nil)
    $stdout.puts "\n== Scraping #{name} page =="

    # Performance note: condition inside loop is bad, but for this case its ok
    get_page_html(url)&.css(selector)&.map do |link_node|
      link_name_node = link_node
      link_name_node = link_node.at_css(name_selector) if name_selector

      { name: link_name_node.content.gsub(/[[:space:]]/, ' ').strip,
        url: BASE_URL + link_node[:href] }
    end
  end

  def print_name_link(name_links)
    name_links.each do |name_link|
      $stdout.puts "  #{name_link[:name].ljust(32)} -> #{name_link[:url]}"
    end
  end
end
