class Ability 
  include CanCan::Ability
  
  def initialize(user)
    can :access, :home
    if user # logged in users
      can :update, User
      can :read, User
      can :destroy, UserSession
      can :read, Bid
      can :create, Bid
      can :read, Job
      can :create, Job
      can :update, Job do |job|
        job.creator == user && !(job.bids.size > 0)
      end
    else  # anonymous
      can :read, Job
      can :create, UserSession
      can :create, User
      can :read, User
    end
  end
end

