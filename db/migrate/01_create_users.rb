class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.timestamps
      t.string :crypted_password, :null => false
      t.string :password_salt, :null => false
      t.string :persistence_token, :null => false
      t.integer :login_count, :default => 0, :null => false
      t.datetime :last_request_at
      t.datetime :last_login_at
      t.datetime :current_login_at
      t.string :last_login_ip
      t.string :current_login_ip
      t.string :name
      t.string :location
      t.string :perishable_token, :default => "", :null => false
      t.string :email, :default => "", :null => false
      t.string :time_zone
    end
    
    add_index :users, :persistence_token
    add_index :users, :last_request_at
    add_index :users, :perishable_token
    add_index :users, :email
  end
  
  #add admin user

  def self.down
    drop_table :users
  end
end
