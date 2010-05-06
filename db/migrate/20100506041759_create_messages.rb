class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.text  :subject
      t.string  :from
      t.text  :body
      t.string :to
      t.string :mail_id
      t.datetime :mail_date
      t.integer :owner_id
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
