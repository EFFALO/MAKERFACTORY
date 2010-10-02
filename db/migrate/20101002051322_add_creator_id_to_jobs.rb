class AddCreatorIdToJobs < ActiveRecord::Migration
  def self.up
    rename_column :jobs, :needer_id, :creator_id
  end

  def self.down
    rename_column :jobs, :creator_id, :needer_id
  end
end
