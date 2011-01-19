class CreateAdminCategories < ActiveRecord::Migration
  def self.up
    create_table :admin_categories do |t|
      t.string :name
      t.integer :parent_id

      t.timestamps
    end
  end

  def self.down
    drop_table :admin_categories
  end
end
