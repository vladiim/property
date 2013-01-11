require_relative '../test_helper.rb'
require_relative '../../app/scrapers/home_sales_scraper.rb'

class House < OpenStruct; end

describe HomeSalesScraper do
  describe '#initialize' do
    before do
      @stream = File.open "#{scraper_fixtures_dir}/home_sales_fixture.html", 'r'
      FakeWeb.register_uri(:get, HomeSalesScraper.create_query_url(200000, 500000, 'New South Wales'),
                         body: @stream, content_type: 'text/html')
      @scraper = HomeSalesScraper.new(200000, 500000, 'New South Wales')
      @scraper.set_first_result
    end

    after { @stream.close }

    describe '#create_house' do
      describe 'house with address doesnt exsist' do
        before do
          House.stubs(:find_by_address).with(result_mock[:address]).returns(false)
          @scraper.create_house
          @scraper.house.stubs(:save).returns(true)
        end


        it 'creates a house object' do
          assert_instance_of House, @scraper.house
        end

        it 'formats and sets the houses properties' do
          assert_equal result_mock[:address],        @scraper.house.address
          assert_equal result_mock[:price],          @scraper.house.price
          assert_equal result_mock[:postcode],       @scraper.house.postcode
          assert_equal result_mock[:beds],           @scraper.house.beds
          assert_equal result_mock[:baths],          @scraper.house.baths
          assert_equal result_mock[:carports],       @scraper.house.carports
          assert_equal result_mock[:classification], @scraper.house.classification
          assert_equal result_mock[:link],           @scraper.house.link
        end
      end
    end

    describe 'house with that address exsists' do
      it 'stops' do
        House.stubs(:find_by_address).with('EXSISTING ADDRESS').returns(true)
        @scraper.stubs(:get_address).returns('EXSISTING ADDRESS')
        assert_equal 'All New Listings Found', @scraper.create_house
      end
    end
  end

  describe '.create_query_url' do
    it 'generates a url based on min ammount, max ammount and state' do
      nsw_url = 'http://www.homesales.com.au/invest/?investorPropertyTypes=All&investorPriceMin=200000&investorPriceMax=500000&investorCashflow=Positive&location=New+South+Wales'
      assert_equal nsw_url, HomeSalesScraper.create_query_url(200000, 500000, 'New South Wales')
    end
  end
end

def scraper_fixtures_dir
  "#{Dir.pwd}/tests/fixtures/scrapers"
end

def result_mock
  {
    address: 'Raymond Terrace, 2324, New South Wales',
    price: 395000,
    postcode: 2324,
    beds: 4,
    baths: 3,
    carports: 2,
    classification: 'house',
    link: "http://www.homesales.com.au/invest/raymond-terrace/hs696785.aspx"
  }
end