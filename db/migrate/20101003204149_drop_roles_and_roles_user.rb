class DropRolesAndRolesUser < ActiveRecord::Migration
  def self.up
    drop_table :roles
    drop_table :roles_users
  end

  def self.down
    create_table :roles do |t|
      t.string :name
      t.timestamps
    end
    
    create_table :roles_users, :id => false, :force => true do |t|
      t.integer :role_id
      t.integer :user_id
    end
  end
end