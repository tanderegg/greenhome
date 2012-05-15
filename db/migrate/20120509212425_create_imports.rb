class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.integer :user_id
      t.integer :feed_id
      t.string :status

      t.timestamps
    end
  end
end
