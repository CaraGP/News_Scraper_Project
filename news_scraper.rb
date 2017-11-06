require 'HTTParty'
require 'Nokogiri'
require 'open-uri'

# Used the tutorial located here: https://medium.com/@LindaHaviv/the-beginner-s-guide-scraping-in-ruby-cheat-sheet-c4f9c26d1b8c

class Scraper

  attr_accessor :parse_page

  def initialize
    doc = HTTParty.get("https://www.qpr.co.uk/news/")
    @parse_page ||= Nokogiri::HTML(doc) # Memorised the @parse_page so it only gets assigned once
  end

  def get_names
    titles = item_container.css(".list-item__header").map { |name| name.text }
    puts ""
    puts "Found titles:"
    puts titles
    titles
  end

  def get_images
    image_urls = item_container.css(".list-item__image").css("img.image").map { |image| image.attr('src') }
    puts ""
    puts "Found images:"
    puts image_urls
    image_urls
  end

  def item_container
    parse_page.css(".list-item")
  end

  scraper = Scraper.new
  names = scraper.get_names
  images = scraper.get_images

  # Takes the data and lays it out nicely, saving it to a file.
  File.open("news.html", 'w'){ |f|
    f.puts '<html><body>'
    (0..2).each do |index| # Three dots don't include last digit. Behave like 0..image_links -1
      puts ""
      puts "Saving article #{index + 1}"
      f.puts "<li>- - - News Article: #{index + 1} - - -"
      puts "#{index + 1}: #{names[index]}"
      image_file_name = "#{index + 1}.jpg"
      f.puts "<img src=\"#{image_file_name}\"> | Headline: #{names[index]}</li>"

      puts "Saving image: #{image_file_name}"
      File.open(image_file_name, 'wb'){ |image_file|
        image_file << open("#{images[index]}").read
      }
    end
    f.puts '</body></html>'
  }
end