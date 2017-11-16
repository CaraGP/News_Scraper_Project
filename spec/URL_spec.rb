require 'spec_helper'
require './news_scraper'
require './data.yml'
require 'rspec'

describe Scraper do
  it 'should get a URL' do
    URL = Scrapper.new
    expect(URL).to have_content(URL)
  end
end