require 'nokogiri'

class Import < ActiveRecord::Base
  attr_accessible :feed_id, :status, :user_id, :feed_file
  has_attached_file :feed_file  

  has_one :feed
  belongs_to :user

	validates_attachment_presence :feed_file
  validates_attachment_content_type :feed_file, :content_type => 'text/xml'

  after_save :process

private
  def process
  	puts 'Processing...'

  	doc = Nokogiri::XML(open(feed_file.path))
  	doc.remove_namespaces!

  	usage_point_entry = nil
  	reading_type_entry = nil
  	interval_block_entry = nil

  	entries = doc.css("entry")

  	puts "Entries: #{entries.size}"

		entries.each do |entry|
  		content = entry.at_css("content")

  		if content
  			puts "Content Child: #{content.first_element_child.name()}"

  			case content.first_element_child.name()
  				when 'UsagePoint'
  					usage_point_entry = content.parent()
  					puts "UsagePoint found"
  				when 'ReadingType'
  					reading_type_entry = content.first_element_child()
  					puts "ReadingType found"
  				when 'IntervalBlock'
  					interval_block_entry = content.first_element_child()
  					puts "IntervalBlack found"
  			end
  		end
  	end

  	if usage_point_entry
			# Extract identifiers from links
			link = usage_point_entry.css("link").first
			usage_point_id = link.attr('href').match(/UsagePoint\/[0-9]+$/)[0].split('/')[1]
			user_id = link.attr('href').match(/User\/[0-9]+\//)[0].split('/')[1]

			# Extrac zipcode from title field
			zipcode = usage_point_entry.css("title").first.inner_text.match(/(\d{5}|\d{5}\-\d{4})/)[0]

			# Construct or find usage point
			usage_point = UsagePoint.find_or_create_by_external_id(usage_point_id)

			usage_point.external_user_id = user_id if usage_point.external_user_id.blank?
			usage_point.zip_code = zipcode if usage_point.zip_code.blank?

			usage_point.save!()

			feed = Feed.create!(:usage_point_id => usage_point.id, :import_id => self.id)

			feed.updated = usage_point_entry.css("updated").inner_text()
			feed.published = usage_point_entry.css("published").inner_text()

			feed.save()

			puts "UsagePointID = #{usage_point_id}"
		else
			raise Exception "UsagePoint not found"
		end

		if reading_type_entry

			for element in reading_type_entry.children()
				puts element.to_s

				feed[element.name.underscore] = element.inner_text.to_i
			end

			feed.save()

		end

		if interval_block_entry

			readings = []

			for element in interval_block_entry.children()
				if element.name == 'IntervalReading'
					for attribute in element.children()
						case attribute.name()
						when 'cost'
							cost = attribute.inner_text.to_i
						when 'value'
							value = attribute.inner_text.to_i
						when 'timePeriod'
							for time_period_element in attribute.children()
								case time_period_element.name()
								when 'start'
									start = Time.at(time_period_element.inner_text.to_i)
								when 'duration'
									duration = time_period_element.inner_text.to_i
								end
							end
						end
					end

					readings << Reading.new(:feed_id => feed.id,
																	:usage_point_id => usage_point.id,
																	:cost => cost,
																	:value => value,
																	:start => start,
																	:duration => duration)
				end
			end

			Reading.import readings
		end
  end
end
