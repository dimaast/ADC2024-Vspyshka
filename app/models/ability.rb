class Ability
  include CanCan::Ability

  def initialize(user)

    guest ||= User.new # guest user

    can :create, EmailSubscription
    can [ :index, :by_tag ], Event
    can :read, Event
    can :read, Meet
    can [ :read, :by_tag ], Community

    return unless user.present?
    if user.role == "admin"
      can [ :read, :manage ], :all

    elsif user.role == "user"
      cannot :manage, :admin # нельзя ничего делать с админ неймспейсом
      can [ :read, :archive ], Event # можно смотреть index, archive и их show
      can :manage, Event, user: user # можно редактировать show, которые принадлежат юзеру
      can :read, Meet # можно смотреть index и его show
      can :manage, Meet, user: user # можно редактировать show, которые принадлежат юзеру
      can [ :edit, :update ], Community, user: user # можно редачить сообщества, которые принадлежат юзеру
      can [ :read, :by_tag ], Community # можно смотреть index, show и by_tag
      can :manage, Comment, user: user
      can :create, Comment

    end

  end
end