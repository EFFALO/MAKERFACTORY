class Ability 
  include CanCan::Ability
  
  def initialize(user)
    can :access, :home
    if user # logged in users
      can :read, Job
      can :create, Job
      can :update, Job
      can :update, User
      can :read, Bid
      can :create, Bid
      can :destroy, UserSession      
      can :read, User
    else  # anonymous
      can :read, Job
      can :create, UserSession
      can :create, User
      can :read, User
    end
  end
end

