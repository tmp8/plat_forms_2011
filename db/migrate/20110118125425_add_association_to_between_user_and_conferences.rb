class AddAssociationToBetweenUserAndConferences < ActiveRecord::Migration
  def self.up
    add_column :conferences, :organizator_id, :integer
  end

  def self.down
    remove_column :conferences, :organizator_id
  end
end
