class AddJobIdToBids < ActiveRecord::Migration
  def self.up
    add_column :bids, :job_id, :integer
  end

  def self.down
    remove_column :bids, :job_id
  end
end
