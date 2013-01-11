module Exceptions
  class AllListingsScraped < StandardError
    def initialize(msg = 'No more listings to scrape')
      super msg
    end
  end
end