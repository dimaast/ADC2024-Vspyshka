# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the user here. For example:
    guest ||= User.new # guest user

    can :create, EmailSubscription

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
      can :read, Community # можно смотреть index и show
      can :manage, Comment, user: user
      can :create, Comment

    end

    # return unless user.present?
    # can :read, :all
    # return unless user.admin?
    # can :manage, :all
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
  end
end
