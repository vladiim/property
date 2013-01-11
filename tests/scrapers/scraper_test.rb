require_relative '../test_helper.rb'
require_relative '../../app/scrapers/scraper.rb'

class MyScrapperClass < OpenStruct
  def initilize(one=nil, two=nil, three=nil); end
end

# describe Scraper do
#   before do
#   	args = [200000, 500000, 'New South Wales']
#     MyScrapperClass.stubs(:new).with(args).returns(MyScrapperClass.new)
#     @scraper = Scraper.new(args)
#   end

#   it 'instantiates the klass with the arguments' do
#   	assert_instance_of MyScrapperClass, @scraper.klass
#   end
# end