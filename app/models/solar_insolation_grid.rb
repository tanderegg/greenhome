class SolarInsolationGrid < ActiveRecord::Base
  attr_accessible :annual, :apr, :aug, :dec, :feb, :gridcode, :jan, :jul, :jun, :mar, :may, :nov, :oct, :sep, :the_geom

  DAYS_PER_MONTH = {'annual' => 365, 
  									'jan' => 31,
  									'feb' => 28,
  									'mar' => 31,
  									'apr' => 30,
  									'may' => 31,
  									'jun' => 30,
  									'jul' => 31,
  									'aug' => 31,
  									'sep' => 30,
  									'oct' => 31,
  									'nov' => 30,
  									'dec' => 31}

  FACTORY = RGeo::Geographic.simple_mercator_factory(:srid => 4326)
  set_rgeo_factory_for_column(:the_geom, FACTORY.projection_factory)

  #EWKB = RGeo::WKRep::WKBGenerator.new(:type_format => :ewkb,
  #  :emit_ewkb_srid => true, :hex_format => true)

  def geom_unproject
  	FACTORY.unproject(self.the_geom)
  end

  def self.containing_latlon(lat, lon)
  	#ewkb = EWKB.generate(FACTORY.point(lon, lat).projection)
  	#point = FACTORY.'point(lon, lat)
    where("ST_Intersects(the_geom, ST_GeographyFromText('SRID=4326;POINT(#{lon} #{lat})'))")
  end

  def calc_production(timeframe, panel_size, panel_num)
  	(((self[timeframe].to_f/1000 * panel_size)*panel_num*DAYS_PER_MONTH[timeframe])/1000).round(0)
  end
end
