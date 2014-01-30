# All back end users (i.e. Active Admin users) are authorized using this class
class AdminAbility
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, ActiveAdmin::Page, :name => "Dashboard"
    can :manage, Plan
    can :manage, Dish
    can :manage, Eaten
    can :manage, Ingredient
    can :manage, ActiveAdmin::Page, :name => "Settings"

    # A super_admin can do the following:
    if user.has_role? 'admin'
      can :manage, :all
      can :manage, User
      can :manage, Role
      can :manage, ActiveAdmin::Comment

    end

  end
end

