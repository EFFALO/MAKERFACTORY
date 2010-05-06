class ChangeDescriptionToMessageOnBids < ActiveRecord::Migration
  def self.up
    rename_column :bids, :description, :message
  end

  def self.down
    rename_column :bids, :message, :description
  end
end
