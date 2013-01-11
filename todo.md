# Tasks

* Think of data required
* Find sources
* Write test scapper
* Write test analysis code
* Write rake tasks to automate scrapping

***

# Data

class Suburb

  use postcode as id

  :suburb_growth, :rental_yield

  demographic data

end

Save data in postcode files e.g. 2000.csv


## homesales.com.au DATA

* Type
* Cash flow strategy    -> bool, positive/negative
* Suburb rental yield   -> float %
* Suburb growth (3 yrs) -> float %

## PRIMARY DATA

* Postcode    -> Int
* Buy price   -> Float (2 dec)
* Date sold   -> Date
* Rent price  -> Float (2 dec)
* Address     -> String
* Bedrooms    -> Int
* Bath        -> Int
* Cars        -> Int
* Live        -> Bool
* Source      -> String (url)
* Type        -> String (unit, town house, house)
* Suburb growth -> float %
* Suburb rental yield -> float %
* MARKET APPRAISAL IF POSS!

## SECONDARY DATA

* Interest rates
* Income
	- Individual
	- Family
	- Household

## Calculations

* Capital growth -> Current value delta sold price
* Repayments     -> Loan - rent
	- % loan
	- interest rate
	- term (years)

## Calculators
* http://www.homesales.com.au/finance/mortgage-calculator.aspx

***

# Sources

Need to get a list of aus postcodes from somewhere

## PRIMARY

* realestate.com.au
* domain.com.au
* http://www.homesales.com.au/
* property.com.au/buy
* Gumtree
* realestateview.com.au/propertydata

## SECONDARY

***

# Programming notes

* Need to have a way to do analysis on same property showing up