class Notifier < ActionMailer::Base
  default_url_options[:host] = "makerfactory.com"
  
  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    from          "noreply@makerfactory.com"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
  
  def bid_notification(bid)
    subject       "New bid on your job: #{bid.job.title}"
    from          "noreply@makerfactory.com"
    recipients    bid.job.creator.email
    sent_on       Time.now
    body          :bid => bid
  end
  
  def bid_award_notification(bid)
    subject       "Your bid on #{bid.job.title} has been awarded!"
    from          "noreply@makerfactory.com"
    recipients    bid.creator.email
    sent_on       Time.now
    body          :bid => bid
  end
end
