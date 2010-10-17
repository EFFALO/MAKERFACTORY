class Ability 
  include CanCan::Ability
  
  def initialize(user)
    # everybody
    can :access, :home
    
    if user # logged in users
      
      can :update, User do |u|
        user == u
      end
      can :read, User
      can :destroy, UserSession
      can :read, Bid do |bid|
        oughta = false
        oughta = true if bid.job.creator == user
        oughta = true if bid.creator == user
        ougtha
      end
      can :create, Bid do |bid|
        oughta = true
        oughta = false if bid.job.creator == user
        oughta = false if user.bids.detect {|b| b.job == bid.job}
        oughta
      end
      can :award, Bid do |bid|
        bid.job.creator == user &&
        !bid.awarded?
      end
      can :read, Job
      # this is a hack, see bids_controller index
      can :read_bids, Job do |job|
        job.creator == user
      end
      can :create, Job
      can :update, Job do |job|
        job.creator == user && !(job.bids.size > 0)
      end
      can :access, :users_active do 
        !(user.created_jobs.empty? && user.bids.empty?)
      end
      
    else  # anonymous
      
      can :read, Job
      can :new, Job
      can :new, Bid
      can :create, UserSession
      can :create, User
      can :read, User
      
    end
  end
end

