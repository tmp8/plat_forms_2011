class RenameCountryToCountryCodeOnConferences < ActiveRecord::Migration
  def self.up
    remove_column :conferences, :country
    add_column :conferences, :country_code, :string
  end

  def self.down
    remove_column :conferences, :country_code
    add_column :conferences, :country, :string
  end
end