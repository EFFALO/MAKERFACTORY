class CreateMailReaders < ActiveRecord::Migration
  def self.up
    create_table :mail_readers do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :mail_readers
  end
end
