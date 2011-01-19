class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :receiver_id
      t.integer :subject_id
      t.string :subject_type
      t.text :text

      t.timestamps
    end
    add_index :notifications, :user_id
    add_index :notifications, :receiver_id
  end

  def self.down
    drop_table :notifications
  end
end