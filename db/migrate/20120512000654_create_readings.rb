class CreateReadings < ActiveRecord::Migration
  def change
    create_table :readings do |t|
      t.integer :feed_id
      t.integer :usage_point_id
      t.integer :cost
      t.integer :reading_quality
      t.datetime :start
      t.integer :duration
      t.integer :value

      t.timestamps
    end
  end
end
