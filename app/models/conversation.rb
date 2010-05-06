class Conversation < ActiveRecord::Base
  has_many :messages, :order => "created_at ASC"

  def self.find_by_mail_id(mail_id)
    self.find(:first, :joins => :messages, :conditions=> ['messages.mail_id = ?', mail_id], :readonly => false)
  end
end