class AddLatlngToJob < ActiveRecord::Migration
  def self.up
    add_column :jobs, :lat, :float
    add_column :jobs, :lng, :float
  end

  def self.down
    remove_column :jobs, :lat
    remove_column :jobs, :lng
  end
end
