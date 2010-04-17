class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string  :description
      t.string  :title
      t.string  :fabrication_type
      t.integer :quantity_needed
      t.date    :deliver_by
      t.string  :deliver_to
      t.integer :needer_id
      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
