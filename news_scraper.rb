require 'HTTParty'
require 'Nokogiri'
require 'open-uri'
require 'yaml'

# Used the tutorial located here: https://medium.com/@LindaHaviv/the-beginner-s-guide-scraping-in-ruby-cheat-sheet-c4f9c26d1b8c

class Scraper

  attr_accessor :parse_page

  def initialize
    data = YAML.load_file("data.yml")
    # Grabs the information from the yml file and stores it as separate variables.
    @url = "#{data['AFCB']['Website']}"
    @container ="#{data['AFCB']['Item_Container']}" # This is the parent selector for both headline and image
    @headline = "#{data['AFCB']['Headline_CSS']}"
    @image = "#{data['AFCB']['Image_CSS']}"
    puts ""
    puts "Storing the following URL: #{@url}"
    puts "Storing the following Article Parent CSS: #{@container}"
    puts "Storing the following Headline CSS: #{@headline}"
    puts "Storing the following Image CSS: #{@image}"
    doc = HTTParty.get("#{@url}")
    @parse_page ||= Nokogiri::HTML(doc) # Memorised the @parse_page so it only gets assigned once
  end


  def item_container
    parse_page.css(@container)
  end

  def get_headlines
    headline = item_container.css(@headline).map { |headline| headline.text }
    puts ""
    puts "Found headlines:"
    puts headline
    headline
  end

  def get_images
    image_urls = item_container.css(@image).map { |image| image.attr('src') || image.attr('data-src') }
    puts ""
    puts "Found images:"
    puts image_urls
    image_urls
  end

  scraper = Scraper.new
  headlines = scraper.get_headlines
  images = scraper.get_images

  # Takes the data and lays it out nicely, saving it to a file.
  File.open("news.html", 'w'){ |f|
    f.puts '<html><body>'
    (0..2).each do |index| # Three dots don't include last digit. Behave like 0..image_links -1
      puts ""
      puts "Saving article #{index + 1}"
      f.puts "<li>- - - News Article: #{index + 1} - - -"
      puts "#{index + 1}: #{headlines[index]}"
      image_file_name = "#{index + 1}.jpg"
      f.puts "<img src=\"#{image_file_name}\"> | Headline: #{headlines[index]}</li>"

      # Saving the images found to the directory
      puts "Saving image: #{image_file_name}"
      File.open(image_file_name, 'wb'){ |image_file|
        image_file << open("#{images[index]}").read
      }
    end
    f.puts '</body></html>'
  }
end