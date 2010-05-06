class AddCreatorToBids < ActiveRecord::Migration
  def self.up
    add_column :bids, :creator_id, :integer
  end

  def self.down
    remove_column :bids, :creator_id
  end
end
