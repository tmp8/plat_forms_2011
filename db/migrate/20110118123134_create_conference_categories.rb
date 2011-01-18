class CreateConferenceCategories < ActiveRecord::Migration
  def self.up
    create_table :conference_categories do |t|
      t.integer :conference_id, :category_id
      t.timestamps
    end
  end

  def self.down
    drop_table :conference_categories
  end
end
