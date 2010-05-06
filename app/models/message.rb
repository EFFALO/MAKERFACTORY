class Message < ActiveRecord::Base
  belongs_to :conversation
  after_create :clean_junk
  
  private
  def clean_junk
    if self.subject.nil?
      self.update_attribute(:subject, "no subject")
    end
    # todo: if no match, set to previous value
    self.update_attribute(:from, self.from.to_s[/(([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,}))/i,1])
  end
end