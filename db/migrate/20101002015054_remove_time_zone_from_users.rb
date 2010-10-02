class RemoveTimeZoneFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :time_zone
  end

  def self.down
    add_column :users, :time_zone, :string
  end
end
