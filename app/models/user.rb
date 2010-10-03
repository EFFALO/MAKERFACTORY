class User < ActiveRecord::Base
  acts_as_authentic

  attr_accessible :name, :password, :password_confirmation, :email, :location, :first_name, :last_name,:role_ids, :description, :equipment, :materials, :url, :image
  validates_format_of :url, :with => URI::regexp(%w(http https))
  validates_length_of :description, :maximum => 555

  # 
  # WON JOBS
  # CREATED JOBS
  # BIDDED JOBS
  has_many :created_jobs, :class_name => "Job", :foreign_key => :creator_id
  has_many :bids, :foreign_key => :creator_id
  
  has_attached_file :image, :styles => { :profile => "290x218>" }
  validates_attachment_size :image, :in => 1..3.megabytes
    
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end

end
