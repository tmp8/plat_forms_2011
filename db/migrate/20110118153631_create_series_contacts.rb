class CreateSeriesContacts < ActiveRecord::Migration
  def self.up
    create_table :series_contacts do |t|
      t.integer :series_id, :contact_id
      t.timestamps
    end
  end

  def self.down
    drop_table :series_contacts
  end
end
