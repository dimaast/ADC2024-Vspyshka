class WelcomeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :search

  # before_action:
  def index
    # События на ближайшую неделю (7 дней) - только из seeds
    seed_event_titles = [
      'Вечер презентаций альбома «Reputation»',
      'Heatwave Sounds',
      'ДИСКОТЕКА 80-90х',
      'Музыкальный фестиваль иконок'
    ]
    
    @upcoming_events = Event.where(hosted_at: Date.today..(Date.today + 7.days))
                           .where("title IN (?) OR title LIKE ?", seed_event_titles, 'Событие №%')
                           .order(:hosted_at)
                           .limit(4)
    
    # Встречи на ближайшую неделю
    @upcoming_meets = Meet.where(hosted_at: Date.today..(Date.today + 7.days))
                         .order(:hosted_at)
                         .limit(2)
    
    # Топ сообщества по подписчикам
    @top_communities = Community.joins(:subscriptions)
                               .group('communities.id')
                               .order('COUNT(subscriptions.id) DESC')
                               .limit(3)
    
    # Последние публикации (события или встречи) - только из seeds
    @publication_type = params[:publication_type] || 'events'
    
    if @publication_type == 'meets'
      @recent_publications = Meet.order(created_at: :desc).limit(4)
    else
      @recent_publications = Event.where("title IN (?) OR title LIKE ?", seed_event_titles, 'Событие №%')
                                 .order(created_at: :desc)
                                 .limit(4)
    end
  end

  def about
  end


  # Правила сервиса
  def rules
  end

  # Лицензионное соглашение
  def license_agreement
  end

  # О команде
  def team
  end

  private

  def get_searchable_title(obj)
    case obj
    when Event
      obj.title
    when Meet
      obj.body.truncate(50)
    when Community
      obj.title
    else
      obj.to_s
    end
  end
end
