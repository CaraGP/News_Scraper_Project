require 'fileutils'
require 'yaml'
require './news_scraper'

FileUtils.mkdir_p 'output'
site_data = YAML.load_file("data.yml")
html = '<html><body>'

site_data.each do |site|
  scraper = Scraper.new(site[1]['website'])
  headlines = scraper.get_headlines(site[1]['headline'])
  images = scraper.get_images(site[1]['image'])
  html += "<h1>#{site[0]}</h1>"
  (0..2).each do |index| # Three dots don't include last digit. Behave like 0..image_links -1
    puts ""
    puts "Saving article #{index + 1}"
    html += "<div><h2>- - - News Article: #{index + 1} - - -</h2>"
    puts "#{index + 1}: #{headlines[index]}"
    image_file_name = "#{site[0]}-#{index + 1}.jpg"
    html += "<img src=\"#{image_file_name}\"> <h2>- - - Headline - - -</h2> <p><strong>#{headlines[index]}</strong></p></div>"

    # Saving the images found to the directory
    puts "Saving image: #{image_file_name}"
    File.open("output/#{image_file_name}", 'wb'){ |image_file|
      image_file << open("#{images[index]}").read
    }
  end
end

html += '</body></html>'

# Takes the data and lays it out nicely, saving it to a file.
File.open("output/news.html", 'w'){ |f|
  f.puts html
}
