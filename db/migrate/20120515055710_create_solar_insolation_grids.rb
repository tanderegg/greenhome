class CreateSolarInsolationGrids < ActiveRecord::Migration
  def change
    create_table :solar_insolation_grids do |t|
      t.string :gridcode
      t.float :jan
      t.float :feb
      t.float :mar
      t.float :apr
      t.float :may
      t.float :jun
      t.float :jul
      t.float :aug
      t.float :sep
      t.float :oct
      t.float :nov
      t.float :dec
      t.float :annual
      t.geometry :the_geom
    end
  end
end
