class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :access, :ckeditor
    can :manage, Ckeditor::Picture, :assetable_id => user.id
  end
end
