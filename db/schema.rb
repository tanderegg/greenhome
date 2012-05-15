# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120515120136) do

  create_table "feeds", :force => true do |t|
    t.integer  "usage_point_id"
    t.integer  "import_id"
    t.datetime "updated"
    t.datetime "published"
    t.string   "currency"
    t.integer  "power_of_ten_multiplier"
    t.integer  "service_category"
    t.integer  "uom"
    t.integer  "time_attribute"
    t.integer  "commodity"
    t.integer  "reading_quality"
    t.integer  "time_of_use"
    t.integer  "summary_measurement"
    t.integer  "service_status"
    t.integer  "accumulation_behavior"
    t.integer  "consumption_tier"
    t.integer  "data_qualifier"
    t.integer  "flow_direction"
    t.string   "provider"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "imports", :force => true do |t|
    t.integer  "user_id"
    t.integer  "feed_id"
    t.string   "status"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "feed_file_file_name"
    t.string   "feed_file_content_type"
    t.integer  "feed_file_file_size"
    t.datetime "feed_file_updated_at"
  end

  create_table "readings", :force => true do |t|
    t.integer  "feed_id"
    t.integer  "usage_point_id"
    t.integer  "cost"
    t.integer  "reading_quality"
    t.datetime "start"
    t.integer  "duration"
    t.integer  "value"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "solar_insolation_grids", :force => true do |t|
    t.string  "gridcode"
    t.float   "jan"
    t.float   "feb"
    t.float   "mar"
    t.float   "apr"
    t.float   "may"
    t.float   "jun"
    t.float   "jul"
    t.float   "aug"
    t.float   "sep"
    t.float   "oct"
    t.float   "nov"
    t.float   "dec"
    t.float   "annual"
    t.spatial "the_geom", :limit => {:srid=>-1, :type=>"geometry"}
  end

  create_table "usage_points", :force => true do |t|
    t.integer  "user_id"
    t.string   "external_id"
    t.string   "zip_code"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "county"
    t.string   "external_user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "zipcodes", :id => false, :force => true do |t|
    t.string  "zipcode"
    t.string  "state_fips"
    t.string  "state"
    t.string  "city"
    t.decimal "latitude",   :precision => 10, :scale => 7
    t.decimal "longitude",  :precision => 10, :scale => 7
  end

end
