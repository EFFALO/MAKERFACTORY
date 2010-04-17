class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
      t.timestamps
    end
    
    create_table :roles_users, :id => false, :force => true do |t|
      t.integer :role_id
      t.integer :user_id
    end
  end
  
  def self.down
    drop_table :role_users
    drop_table :roles
  end
end
