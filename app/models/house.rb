class House < ActiveRecord::Base

  attr_accessible :address, :price, :postcode, :beds, :baths,
                  :classification, :carports, :link # :market_appraisal, :sold_on

end