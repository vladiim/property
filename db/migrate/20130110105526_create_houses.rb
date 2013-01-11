class CreateHouses < ActiveRecord::Migration
  def up
  	create_table :houses do |t|
  	  t.string :address
  	  t.integer :price, precision: 6
  	  t.integer :postcode, precision: 4
  	  t.integer :beds, precision: 1
  	  t.integer :baths, precision: 1
  	  t.integer :carports, precision: 1
  	  t.string :classification
  	  t.string :link
  	  t.timestamps
  	end
  end

  def down
  	drop_table :properties
  end
end