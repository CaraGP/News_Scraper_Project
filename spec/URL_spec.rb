require 'rspec'
require 'spec_helper'
require 'webmock/rspec'
require './news_scraper'

describe Scraper do

  it 'should be able to mock the HTML of a page' do

    # the url we will use in this example
    url = 'http://www.google.com'

    # setting up the mock (or stub) - :any means any type of request (get, post etc)
    stub_request(:any, url).
        to_return(body: "<html><body>sup</body></html>", status: 200)

    # create the instance of the Scraper
    myScraper = Scraper.new url

    # read the parse_page property from the instance - it should equal the HTML defined in the mock above
    puts myScraper.parse_page
  end
end
