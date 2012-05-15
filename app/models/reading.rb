class Reading < ActiveRecord::Base
  attr_accessible :cost, :duration, :feed_id, :reading_quality, :start, :usage_point_id, :value

  belongs_to :usage_point
  belongs_to :feed
end
