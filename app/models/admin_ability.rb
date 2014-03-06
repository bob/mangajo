# All back end users (i.e. Active Admin users) are authorized using this class
class AdminAbility
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    alias_action :new, :create, :edit, :update, :destroy, :to => :change
    alias_action :read, :create, :to => :read_create

    can :read, ActiveAdmin::Page, :name => "Dashboard"
    can :manage, Plan
    can :manage, PlanItem
    can :manage, Dish
    can :manage, Eaten

    #can :read, Ingredient
    #can :change, Ingredient, :ration => {:user_id => user.id}
    can :manage, Ingredient

    can :manage, ActiveAdmin::Page, :name => "Settings"
    can :manage, Ration

    # A super_admin can do the following:
    if user.has_role? 'admin'
      can :manage, :all
      can :manage, User
      can :manage, Role
      can :manage, ActiveAdmin::Comment

    end

  end
end

