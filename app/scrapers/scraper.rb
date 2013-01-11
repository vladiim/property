class Scraper

  attr_accessor :worker

  def scrape_home_sales!
  	HomeSalesScraper::STATES.each do |state|
      @worker = HomeSalesScraper.new(350000, 500000, state)

      puts "Created worker: #{@worker}, with: #{state}, on url: #{@worker.url}"
      create_and_scrape
  	end
  end

  private

  def create_and_scrape
  	create_houses
  	move_to_next_page_until_finished
  end

  def create_houses
  	@worker.results.each do |r|
  	  @worker.result = r
  	  @worker.create_house
  	end
  end

  def move_to_next_page_until_finished
  	# while @worker.next_link? && @worker.agent.page.uri.to_i < 100 do
  	while @worker.next_link? do
  	  @worker.next_page
  	  puts "ON PAGE: #{@worker.agent.page.uri}"
  	  @worker.get_results
  	  create_houses
    end
  end
end