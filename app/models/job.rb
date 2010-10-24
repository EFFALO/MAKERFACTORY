class Job < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User'
  has_many :bids
  
  validates_presence_of :title, :description, :fabrication_type, :quantity_needed, :deliver_by, :deliver_to
  validates_length_of :description, :within => 0..555, :message => 'must be less than 555 characters.'
  validates_numericality_of :quantity_needed, :greater_than => 0
  validate :validate_deliver_by
  
  image_options = {:styles => { :profile => "290x218>", :small => '64x64#'}}
  has_attached_file :image1, image_options
  has_attached_file :image2, image_options
  has_attached_file :image3, image_options
  
  has_attached_file :blueprint

  # This validation is broken in current Paperclip. It doesn't allow_nil.
  # image_size = {:in => 1..3.megabytes}
  #  validates_attachment_size :image1, image_size
  #  validates_attachment_size :image2, image_size
  #  validates_attachment_size :image3, image_size
  #  validates_attachment_size :blueprint, :in => 1..5.megabytes
  image_validations = {:in => 1..3.megabytes, :allow_nil => true, :message => 'Images must be less than 3 megabytes.'}
  validates_inclusion_of :image1_file_size, image_validations
  validates_inclusion_of :image2_file_size, image_validations
  validates_inclusion_of :image3_file_size, image_validations
  validates_inclusion_of :blueprint_file_size, :in => 1..5.megabytes, :allow_nil => true, :message => 'Blueprints must be less than 5 megabyes.'

  named_scope :active, {
    :conditions => ["created_at > ?", 3.weeks.ago.to_s(:db)]
  }

  def expired?
    self.created_at < (Time.now - 3.weeks)
  end

  private
  
    def validate_deliver_by 
      if self.deliver_by <= Date.today
        errors.add(:quantity, "deliver by can't be in the past.")
      end
    end

end
