class CreateBids < ActiveRecord::Migration
  def self.up
    create_table :bids do |t|
      t.string :description
      t.integer :quantity
      t.timestamps
    end
  end

  def self.down
    drop_table :bids
  end
end
