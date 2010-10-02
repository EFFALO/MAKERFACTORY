class Bid < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User'
  belongs_to :job
  
  validates_length_of :message, :within => 1...333, :message => "must be less than 333 characters"
  validate :validate_quantity
  
  def validate_quantity
    if self.quantity > self.job.quantity_needed
      errors.add(:quantity, "can't be more than the job is asking for")
    end
  end
end
