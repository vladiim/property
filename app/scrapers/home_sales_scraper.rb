require 'mechanize'
require 'uri'

class HomeSalesScraper
  URL = 'http://www.homesales.com.au'
  STATES = ['Australian Capital Territory', 'New South Wales',
            'Northern Territory', 'Queensland', 'South Australia',
            'Tasmania', 'Victoria', 'Western Australia']

  attr_accessor :agent, :results, :result, :house

  def initialize
  	@agent = Mechanize.new
  	@agent.get HomeSalesScraper.results_url
    get_results
  end

  def get_results
    @results = @agent.page.search '.result-item'
  end

  def create_house
    return 'All New Listings Found' if House.find_by_address(get_address)
    @house                = House.new
    @house.address        = get_address
    @house.price          = get_price
    @house.postcode       = get_postcode
    @house.beds           = get_beds
    @house.baths          = get_baths
    @house.carports       = get_carports
    @house.classification = get_classification
    @house.link           = get_link
    @house.save
  end

  def set_first_result
  	@result = @results.first
  end

  def self.create_query_url(price_min, price_max, location)
    URL + "/invest/?" + URI.encode_www_form(investorPropertyTypes: 'All', investorPriceMin: price_min, 
                             investorPriceMax: price_max, investorCashflow: 'Positive',
                             location: location)
  end

  def self.results_url
    URL + '/invest/?investorPropertyTypes=All%2c0%2c2%2c1%2c5&investorPriceMin=200000&investorPriceMax=500000&investorCashflow=Positive&location=New+South+Wales%2c+State'
  end

  private

  def get_price
    result = @result.search('div.primary-price p').text
    result = result.scan(/\d/)
    result.join.to_i
  end

  def get_address
  	@result.search('a h2').text.strip
  end

  def get_postcode
    get_address.match(/\d{4}/).to_s.to_i
  end

  def get_beds
    result = @result.search('div.property-features ul li.item-bed').text
    result.match(/\w/).to_s.to_i
  end

  def get_baths
    result = @result.search('div.property-features ul li.item-bath').text
    result.match(/\w/).to_s.to_i
  end

  def get_carports
    result = @result.search('div.property-features ul li.item-carports').text
    result.match(/\w/).to_s.to_i
  end

  def get_classification
    @result.search('ul.investor-stats li').first.text.sub(/Property Type/, '').strip.downcase
  end

  def get_link
    URL + @result.search('a').first[:href]
  end
end