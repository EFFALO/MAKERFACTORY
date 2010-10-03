class AddImagesAndBlueprintToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :image1_file_name, :string
    add_column :jobs, :image1_content_type, :string
    add_column :jobs, :image1_file_size, :integer
    add_column :jobs, :image1_updated_at, :datetime
    
    add_column :jobs, :image2_file_name, :string
    add_column :jobs, :image2_content_type, :string
    add_column :jobs, :image2_file_size, :integer
    add_column :jobs, :image2_updated_at, :datetime
    
    add_column :jobs, :image3_file_name, :string
    add_column :jobs, :image3_content_type, :string
    add_column :jobs, :image3_file_size, :integer
    add_column :jobs, :image3_updated_at, :datetime
    
    add_column :jobs, :blueprint_file_name, :string
    add_column :jobs, :blueprint_content_type, :string
    add_column :jobs, :blueprint_file_size, :integer
    add_column :jobs, :blueprint_updated_at, :datetime
  end

  def self.down
    remove_column :jobs, :image1_updated_at
    remove_column :jobs, :image1_file_size
    remove_column :jobs, :image1_content_type
    remove_column :jobs, :image1_file_name
    
    remove_column :jobs, :image2_updated_at
    remove_column :jobs, :image2_file_size
    remove_column :jobs, :image2_content_type
    remove_column :jobs, :image2_file_name
    
    remove_column :jobs, :image3_updated_at
    remove_column :jobs, :image3_file_size
    remove_column :jobs, :image3_content_type
    remove_column :jobs, :image3_file_name
    
    remove_column :jobs, :blueprint_updated_at
    remove_column :jobs, :blueprint_file_size
    remove_column :jobs, :blueprint_content_type
    remove_column :jobs, :blueprint_file_name
  end
end