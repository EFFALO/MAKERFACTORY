class AddDescriptionToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :description, :string
    add_column :users, :equipment, :string
    add_column :users, :materials, :string
  end

  def self.down
    remove_column :users, :materials
    remove_column :users, :equipment
    remove_column :users, :description
  end
end
