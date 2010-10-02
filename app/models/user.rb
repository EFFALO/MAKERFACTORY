class User < ActiveRecord::Base
  acts_as_authentic
  
  has_and_belongs_to_many :roles
  attr_accessible :name, :password, :password_confirmation, :email, :location, :first_name, :last_name,:role_ids, :time_zone, :description, :equipment, :materials, :url
  validates_format_of :url, :with => URI::regexp(%w(http https))

  # 
  # WON JOBS
  # CREATED JOBS
  # BIDDED JOBS
  has_many :created_jobs, :class_name => "Job"

  
  #for declarative authorization
  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end

end
