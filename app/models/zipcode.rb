class Zipcode < ActiveRecord::Base
  attr_accessible :city, :latitude, :longitude, :state, :state_fips, :zipcode
end
