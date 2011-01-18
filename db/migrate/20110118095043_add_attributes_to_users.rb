# GM

class AddAttributesToUsers < ActiveRecord::Migration
  def self.up
    add_column  :users, :full_name, :string
    add_column  :users, :username, :string
    add_column  :users, :city, :string
    add_column  :users, :country, :string
    add_column  :users, :lat, :decimal, :null => true, :precision => 12, :scale => 8
    add_column  :users, :lng, :decimal, :null => true, :precision => 12, :scale => 8
    add_column  :users, :confirmation_token, :string
    add_column  :users, :confirmation_sent_at, :datetime
    add_column  :users, :confirmed_at, :datetime
  end

  def self.down
    remove_column  :users, :full_name
    remove_column  :users, :username
    remove_column  :users, :city
    remove_column  :users, :country
    remove_column  :users, :lat
    remove_column  :users, :lng
    remove_column  :users, :confirmation_token
    remove_column  :users, :confirmation_sent_at
    remove_column  :users, :confirmed_at
  end
end
