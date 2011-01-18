class CreateSeries < ActiveRecord::Migration
  def self.up
    create_table :series do |t|
      t.string :name
      t.timestamps
    end
    add_column :conferences, :series_id, :integer
  end

  def self.down
    remove_column :conferences, :series_id
    drop_table :series
  end
end