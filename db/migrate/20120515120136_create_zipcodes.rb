class CreateZipcodes < ActiveRecord::Migration
  def change
    create_table :zipcodes, :id => false do |t|
      t.string :zipcode, :primary_key => true
      t.string :state_fips
      t.string :state
      t.string :city
      t.decimal :latitude, :precision => 10, :scale => 7
      t.decimal :longitude, :precision => 10, :scale => 7
    end
  end
end
