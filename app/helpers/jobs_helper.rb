module JobsHelper
  def can_bid_on_job?(user, job)
    bidded_jobs = user.bids.map {|bid| bid.job}
    
    !bidded_jobs.include?(job) && !owns_job?(user, job)
  end
  
  def owns_job?(user, job)
    user.created_jobs.include?(job)
  end
end
