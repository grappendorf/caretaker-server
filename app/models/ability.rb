class Ability
  include CanCan::Ability

  def initialize(user)

    alias_action :names, :to => :read

    user ||= User.new

    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :manager
      can :manage, Dashboard, user: user
      can :manage, Widget, dashboard: { user: user }
      can :manage, [Device, DeviceAction, DeviceScript, Room, Floor, Building]
      can :execute, DeviceAction
    elsif user.has_role? :user
      can :manage, Dashboard, user: user
      can :manage, Widget, dashboard: { user: user }
      can [:read, :execute], DeviceAction
      can [:read, :image], [Device] + Device.models
      can [:read, :update], User, id: user.id
    end

  end
end
