# origin: M
class CreateFriendships < ActiveRecord::Migration
  def self.up
    create_table :friendships do |t|
      t.integer :user_id
      t.integer :friend_id
      t.integer :status, :default => 0 # outstanding
      t.datetime :status_changed_at

      t.timestamps
    end
    add_index :friendships, :friend_id
    add_index :friendships, :user_id
  end


  def self.down
    remove_index :friendships, :user_id
    remove_index :friendships, :friend_id
    drop_table :friendships
  end
end