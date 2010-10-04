class Ability 
  include CanCan::Ability
  
  def initialize(user)
    # everybody
    can :access, :home
    
    if user # logged in users
      
      can :update, User
      can :read, User
      can :destroy, UserSession
      can :read, Bid
      can :create, Bid do |bid|
        oughta = true
        oughta = false if bid.job.creator == user
        oughta = false if user.bids.detect {|b| b.job == bid.job}
        oughta
      end
      can :read, Job
      can :create, Job
      can :update, Job do |job|
        job.creator == user && !(job.bids.size > 0)
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

