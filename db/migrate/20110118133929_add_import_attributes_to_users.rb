class AddImportAttributesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :gps, :string
    add_column :users, :country_code, :string
  end

  def self.down
    remove_column :users, :country_code
    remove_column :users, :gps
  end
end