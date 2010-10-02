class Job < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User'
  has_many :bids
  
  validates_presence_of :title, :description, :fabrication_type, :quantity_needed, :deliver_by, :deliver_to
  validates_length_of :description, :within => 0..555, :message => 'must be less than 555 characters.'
  validates_numericality_of :quantity_needed, :greater_than => 0
  validate :validate_deliver_by
  
  private
  
    def validate_deliver_by 
      if self.deliver_by <= Date.today
        errors.add(:quantity, "deliver by can't be in the past.")
      end
    end
end
