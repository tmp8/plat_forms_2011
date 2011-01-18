class CreateConferences < ActiveRecord::Migration
  def self.up
    create_table :conferences do |t|
      t.string :version, :name, :country, :city, :location, :gps
      t.decimal :lat, :precision => 12, :scale => 8
      t.decimal :lng, :precision => 12, :scale => 8
      t.integer :creator_id, :series_id
      t.date :startdate, :enddate
      t.text :description, :venue, :accomodation, :howtofind
      t.timestamps
    end
  end

  def self.down
    drop_table :conferences
  end
end
