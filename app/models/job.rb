class Job < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User'
  has_many :bids
  
  validates_presence_of :title, :description, :fabrication_type, :quantity_needed, :deliver_by, :deliver_to
  validates_length_of :description, :within => 0..555, :message => 'must be less than 555 characters.'
  validates_numericality_of :quantity_needed, :greater_than => 0
  validate :validate_deliver_by
  
  image_size = {:less_then => 3.megabytes}
  validates_attachment_size :image1, image_size
  validates_attachment_size :image2, image_size
  validates_attachment_size :image3, image_size
  validates_attachment_size :blueprint, :less_than => 5.megabytes
  
  image_options = {:styles => { :profile => "290x218>" }}
  has_attached_file :image1, image_options
  has_attached_file :image2, image_options
  has_attached_file :image3, image_options
  
  has_attached_file :blueprint
  private
  
    def validate_deliver_by 
      if self.deliver_by <= Date.today
        errors.add(:quantity, "deliver by can't be in the past.")
      end
    end
end
