class RemoveOldEmailTables < ActiveRecord::Migration
  def self.up
    drop_table :messages
    drop_table :mail_readers
  end

  def self.down
  end
end
