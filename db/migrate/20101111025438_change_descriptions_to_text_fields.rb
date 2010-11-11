class ChangeDescriptionsToTextFields < ActiveRecord::Migration
  def self.up
    change_column(:users, :description, :text)
    change_column(:bids, :message, :text)
    change_column(:jobs, :description, :text)
  end

  def self.down
    change_column(:users, :description, :string)
    change_column(:bids, :message, :string)
    change_column(:jobs, :description, :string)
  end
end
