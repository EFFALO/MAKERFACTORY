class User < ActiveRecord::Base
  acts_as_authentic

  attr_accessible :name, :password, :password_confirmation, :email, :location, :first_name, :last_name,:role_ids, :description, :equipment, :materials, :url, :image
  validates_format_of :url,
    :with => URI::regexp(%w(http https)),
    :allow_blank => true,
    :message => 'is required to have an http:// or https://'
  validates_length_of :description, :maximum => 555

  has_many :created_jobs, :class_name => "Job", :foreign_key => :creator_id
  has_many :bids, :foreign_key => :creator_id
  
  has_attached_file :image, :styles => { :profile => "290x218>" }
  # validates_attachment_size :image, :in => 1..3.megabytes
  validates_inclusion_of :image_file_size, :in => 1..3.megabytes, :allow_nil => true, :message => 'Images must be less than 3 megabytes.'

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
  
  def received_bid_award_count
    self.bids.count(:conditions => ["awarded = ?", true])
  end
  
  def sent_bid_award_count
    Bid.count(:conditions => ["awarded = ? AND jobs.creator_id = ?", true, self.id], :joins => "JOIN jobs ON jobs.id = job_id")
  end

end
