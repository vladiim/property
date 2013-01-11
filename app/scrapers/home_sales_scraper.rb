require 'mechanize'
require 'uri'

class HomeSalesScraper
  URL = 'http://www.homesales.com.au'
  STATES = ['Australian Capital Territory', 'New South Wales',
            'Northern Territory', 'Queensland', 'South Australia',
            'Tasmania', 'Victoria', 'Western Australia']

  attr_accessor :agent, :results, :result, :house, :url

  def initialize(price_min, price_max, state)
  	@agent = Mechanize.new
    @url = HomeSalesScraper.create_query_url(price_min, price_max, state)
  	@agent.get @url
    get_results
  end

  def get_results
    @results = @agent.page.search '.result-item'
  end

  def create_house
    return if House.find_by_address(get_address)
    @house                = House.find_or_initialize_by_address(get_address)
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

  def self.create_query_url(price_min, price_max, location)
    URL + "/invest/?" + URI.encode_www_form(investorPropertyTypes: 'All%2c0%2c2%2c1%2c5', investorPriceMin: price_min, 
                             investorPriceMax: price_max, investorCashflow: 'Positive',
                             location: location) + '%2c+State'
  end

  def next_page
    return unless next_link?
    node = find_next_link_node
    link = node[0].attributes
    Mechanize::Page::Link.new(link, @agent, @agent.page).click
  end

  def next_link?
    true unless find_next_link_node.empty?
  end

  private

  def find_next_link_node
    @agent.page.search('div.pagination ul ul li.next a')
  end

  def get_price
    result = @result.search('div.primary-price p').text
    result = result.scan(/\d/)
    result[0...6].join.to_i # the [0...6] is to avoid ranges
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