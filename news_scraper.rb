require 'HTTParty'
require 'Nokogiri'
require 'open-uri'

# Used the tutorial located here: https://medium.com/@LindaHaviv/the-beginner-s-guide-scraping-in-ruby-cheat-sheet-c4f9c26d1b8c

class Scraper

  attr_accessor :parse_page

  def initialize(url)
    doc = HTTParty.get(url)
    @parse_page = Nokogiri::HTML(doc) # Memorised the @parse_page so it only gets assigned once
  end

  def get_headlines(selector)
    headline = @parse_page.css(selector).map { |headline| headline.text }
    puts ""
    puts "Found titles:"
    puts headline
    headline
  end

  def get_images(selector)
    image_urls = @parse_page.css(selector).map { |image| image.attr('src') || image.attr('data-src') }
    puts ""
    puts "Found images:"
    puts image_urls
    image_urls
  end
end
