class RemoveConversationsTable < ActiveRecord::Migration
  def self.up
    drop_table(:conversations)
  end

  def self.down
  end
end
