class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.integer   :usage_point_id
      t.integer   :import_id
      t.datetime  :updated
      t.datetime  :published
      t.string    :currency                 # Follows codes defined in ISO 4217. Full list at tiny.cc/4217. 0 - Not Applicable 36 - Australian Dollar 124 - Canadian Dollar 840 - US Dollar 978 - Euro
      t.integer   :power_of_ten_multiplier  # Valid values include: 0 = None 1 = deca=x10 2 = hecto=x100 -3 = mili=x10-3 3 = kilo=x1000 6 = Mega=x106 -6 = micro=x10-3 9 = Giga=x109
      t.integer   :service_category         # Valid values include: 0 - electricity 1 - gas 2 - water 4 - pressure 5 - heat 6 - cold 7 - communication 8 - time
      t.integer   :uom                      # Valid values include: 0 = Not Applicable 5 = A (Current) 29 = Voltage 31 = J (Energy joule) 33 = Hz (Frequency) 38 = Real power (Watts) 42 = m3 (Cubic Meter) 61 = VA (Apparent power) 63 = VAr (Reactive power) 65 = Cos? (Power factor) 67 = V� (Volts squared) 69 = A� (Amp squared) 71 = VAh (Apparent energy) 72 = Real energy (Watt-hours) 73 = VArh (Reactive energy) 106 = Ah (Ampere-hours / Available Charge) 119 = ft3 (Cubic Feet) 122 = ft3/h (Cubic Feet per Hour) 125 = m3/h (Cubic Meter per Hour) 128 = US gl (US Gallons) 129 = US gl/h (US Gallons per Hour) 130 = IMP gl (Imperial Gallons) 131 = IMP gl/h (Imperial Gallons per Hour) 132 = BTU 133 = BTU/h 134 = Liter 137 = L/h (Liters per Hour) 140 = PA(gauge) 155 = PA(absolute) 169 = Therm   
      t.integer   :time_attribute           # Valid values include: 0 = Not Applicable 1 = 10-minute 2 = 15-minute 4 = 24-hour 5 = 30-minute 7 = 60-minute 11 = Daily 13 = Monthly 15 = Present 16 = Previous 24 = Weekly 32 = ForTheSpecifiedPeriod 79 = Daily30minuteFixedBlock
      t.integer   :commodity                # Valid values include: 0 = Not Applicable 1 = Electricity metered value 4 = Air 7 = NaturalGas 8 = Propane 9 = PotableWater 10 = Steam 11 = WasteWater 12 = HeatingFluid 13 = CoolingFluid
      t.integer   :reading_quality          # List of codes indicating the quality of the reading, using specification: 0 - valid: data that has gone through all required validation checks and either passed them all or has been verified 7 - manually edited: Replaced or approved by a human 8 - estimated using reference day: data value was replaced by a machine computed value based on analysis of historical data using the same type of measurement. 9 - estimated using linear interpolation: data value was computed using linear interpolation based on the readings before and after it 10 - questionable: data that has failed one or more checks 11 - derived: data that has been calculated (using logic or mathematical operations), not necessarily measured directly 12 - projected (forecast): data that has been calculated as a projection or forecast of future readings 13 - mixed: indicates that the quality of this reading has mixed characteristics 14 - raw: data that has not gone through the validation, editing and estimation process 15 - normalized for weather: the values have been adjusted to account for weather, in order to compare usage in different climates 16 - other: specifies that a characteristic applies other than those defined 17 - validated: data that has been validated and possibly edited and/or estimated in accordance with approved procedures 18 - verified: data that failed at least one of the required validation checks but was determined to represent actual usage
      t.integer   :time_of_use              # Valid values include: 0 = NotApplicable 1 = TOU A 2 = TOU B 3 = TOU C 4 = TOU D 5 = TOU E 6 = TOU F 7 = TOU G 8 = TOU H 9 = TOU I 10 = TOU J 11 = TOU K 12 = TOU L 13 = TOU M 14 = TOU N 15 = TOU O
      t.integer   :summary_measurement      # Value of summary measurement
      t.integer   :service_status           # The current status of the service. 0 = Unavailable 1 = Normal, operational
      t.integer   :accumulation_behavior    # Valid values include: 0 = Not Applicable 1 = BulkQuantity 3 = Cumulative 4 = DeltaData 6 = Indicating 9 = Summation 12 = Instantaneous
      t.integer   :consumption_tier         # Valid values include: 0 = Not Applicable 1 = Block Tier 1 2 = Block Tier 2 3 = Block Tier 3 4 = Block Tier 4 5 = Block Tier 5 6 = Block Tier 6 7 = Block Tier 7 8 = Block Tier 8 9 = Block Tier 9 10 = Block Tier 10 11 = Block Tier 11 12 = Block Tier 12 13 = Block Tier 13 14 = Block Tier 14 15 = Block Tier 15 16 = Block Tier 16
      t.integer   :data_qualifier           # Valid values include: 0 = Not Applicable 2 = Average 8 = Maximum 9 = Minimum 12 = Normal
      t.integer   :flow_direction           # Valid values include: 0 = Not Applicable 1 = Forward 19 = Reverse
      t.string    :provider

      t.timestamps
    end
  end
end
