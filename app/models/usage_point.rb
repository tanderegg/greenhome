class UsagePoint < ActiveRecord::Base
  attr_accessible :address, :city, :county, :external_id, :external_user_id, :provider, :state, :user_id, :zip_code

  has_many :readings
  belongs_to :user
  has_many :feeds

  before_save :process_address

  def formatted_address
  	if address.blank?
  		address_text = '<span class="unknown-data">Unknown Address</span>'
  	else
  		address_text = address
  	end

  	if city.blank?
  		city_state_text = '<span class="unknown-data">Unknown City, State</span>'
  	else
  		city_state_text = "#{city}, #{state}"
  	end

  	if zip_code.blank?
  		zip_text = '<span class="unknown-data">Unknown Zip</span>'
  	else
  		zip_text = zip_code
  	end

  	"#{address_text}, #{city_state_text} #{zip_text}"
  end

	private
	  def process_address
	  	if not zip_code.blank?
	  		puts "Zipcode not blank!"
	  		begin
	  			zipcode_data = Zipcode.find(:first, :conditions => {:zipcode => zip_code})
	  			puts "Zipcode data #{zipcode_data.city}"
	  			self.city = zipcode_data.city
	  			self.state = zipcode_data.state
	  		rescue
	  			puts "Zipcode not found"
	  			zipcode_data = nil
	  		end
	  	else
	  		puts "Zipcode blank!"
	  	end
	  end
end
