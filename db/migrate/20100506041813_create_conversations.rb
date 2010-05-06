class CreateConversations < ActiveRecord::Migration
  def self.up
    add_column :messages, :conversation_id, :integer
    create_table :conversations do |t|
      t.timestamps
    end
  end

  def self.down
    remove_column :messages, :conversation_id
    drop_table :conversations
  end
end
