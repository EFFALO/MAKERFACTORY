class Bid < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User'
  belongs_to :job
  
  validates_uniqueness_of :job_id, :scope => :creator_id, :message => "You can't bid on the same job more than once."
  validates_presence_of :message, :message => 'Your bid must include a message.'
  validates_length_of :message, :within => 0..333, :message => 'must be less than 333 characters.'
  validates_numericality_of :quantity, :greater_than => 0
  validate :validate_quantity, :validate_nonownership
  
  def validate_quantity
    if self.quantity > self.job.quantity_needed
      errors.add(:quantity, "can't be more than the job is asking for")
    end
  end
  
  def validate_nonownership
    if self.job.creator == self.creator
      errors.add(:creator, "You can't bid on your own job.")
    end
  end
end
