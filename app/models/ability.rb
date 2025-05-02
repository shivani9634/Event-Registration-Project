class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :index, :show, to: :read
    user ||= User.new

    role_type = user.role&.role_type

    case role_type
    when "admin"
      can :manage, :all
    when "organizer"
      can :manage, Event
      can :read, Category
      can :manage, EventRegistration
      can :manage, DiscountCode
    when "attendee"
      can :create, User
      if user.persisted?
        can :read, User, id: user.id
        can :update, User, id: user.id
        can :read, Event
        can :read, Category
        can :create, EventRegistration
        can :read, DiscountCode
        can [ :read, :create ], Payment, event_registration: { user_id: user.id }
        can :update, Payment, event_registration: { user_id: user.id }
      else
      can :read, Event
      end
    else
        can :read, Event
    end
  end
end
