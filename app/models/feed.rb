class Feed < ActiveRecord::Base
  attr_accessible :content, :currency, :import_id, :powerOfTenMultiplier, :published, :reading_type, :updated, :usage_point_id
  
  has_many :readings
  belongs_to :import
  belongs_to :user
  belongs_to :usage_point
end
