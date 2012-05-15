class CreateUsagePoints < ActiveRecord::Migration
  def change
    create_table :usage_points do |t|
      t.integer :user_id
      t.string :external_id
      t.string :zip_code
      t.string :address
      t.string :city
      t.string :state
      t.string :county
      t.string :external_user_id

      t.timestamps
    end
  end
end
