class AddAwardedFlagToBids < ActiveRecord::Migration
  def self.up
    add_column :bids, :awarded, :boolean
  end

  def self.down
    remove_column :bids, :awarded
  end
end
