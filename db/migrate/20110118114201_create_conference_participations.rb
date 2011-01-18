# origin: M

class CreateConferenceParticipations < ActiveRecord::Migration
  def self.up
    create_table :conference_participations do |t|
      t.integer :user_id
      t.integer :conference_id

      t.timestamps
    end
    add_index :conference_participations, :user_id
    add_index :conference_participations, :conference_id
    
    add_index :conference_participations, [:user_id, :conference_id], :unique => true
  end

  def self.down
    drop_table :conference_participations
  end
end