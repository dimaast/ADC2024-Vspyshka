class EventsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  layout "application", only: %i[ show new edit create update destroy ]
  load_and_authorize_resource except: [ :index ]
  before_action :set_event, only: %i[ show edit update destroy ]

  def index
    @categories = Tag.categories_list
    @tags = Tag.tags_list

    @category = params[:category]
    @tag = params[:tag]
    @place = params[:place]
    @date = params[:date]
    @sort = params[:sort]

    @events = Event.where("hosted_at > ?", DateTime.now)
    @events = @events.tagged_with(@category, on: :categories) if @category.present?
    @events = @events.tagged_with(@tag, on: :tags) if @tag.present?
    @events = @events.where(placed_at: @place) if @place.present?
    @events = @events.where("DATE(hosted_at) = ?", @date) if @date.present?

    case @sort
    when 'new'
      @events = @events.order(created_at: :desc)
    when 'recommended'
      if current_user

        user_tags = current_user.tag_list
        if user_tags.any?

          @events = @events.left_joins(:responses, :taggings)
                           .group(:id)
                           .order(Arel.sql("CASE WHEN events.id IN (SELECT DISTINCT taggable_id FROM taggings WHERE taggable_type = 'Event' AND tag_id IN (SELECT id FROM tags WHERE name IN (#{user_tags.map { |tag| "'#{tag}'" }.join(',')}))) THEN 100 ELSE 0 END + COUNT(responses.id) DESC"))
        else

          @events = @events.left_joins(:responses).group(:id).order('COUNT(responses.id) DESC')
        end
      else

        @events = @events.left_joins(:responses).group(:id).order('COUNT(responses.id) DESC')
      end
    else

      @events = @events.left_joins(:responses).group(:id).order('COUNT(responses.id) DESC')
    end
    
    @events = @events.page(params[:page]).per(10)

    @user_events = current_user&.events&.where("hosted_at > ?", DateTime.now)&.page(params[:user_page]).per(10) if current_user
  end

  def by_tag
    @categories = Tag.categories_list
    @tags = Tag.tags_list
    @tag = params[:tag]
    @category = params[:category]
    @date = params[:date]
    @sort = params[:sort]
    @events = Event.where("hosted_at > ?", DateTime.now)
    @events = @events.tagged_with(@category, on: :categories) if @category.present?
    @events = @events.tagged_with(@tag, on: :tags) if @tag.present?
    @events = @events.where("DATE(hosted_at) = ?", @date) if @date.present?

    case @sort
    when 'new'
      @events = @events.order(created_at: :desc)
    when 'recommended'
      if current_user

        user_tags = current_user.tag_list
        if user_tags.any?

          @events = @events.left_joins(:responses, :taggings)
                           .group(:id)
                           .order(Arel.sql("CASE WHEN events.id IN (SELECT DISTINCT taggable_id FROM taggings WHERE taggable_type = 'Event' AND tag_id IN (SELECT id FROM tags WHERE name IN (#{user_tags.map { |tag| "'#{tag}'" }.join(',')}))) THEN 100 ELSE 0 END + COUNT(responses.id) DESC"))
        else

          @events = @events.left_joins(:responses).group(:id).order('COUNT(responses.id) DESC')
        end
      else

        @events = @events.left_joins(:responses).group(:id).order('COUNT(responses.id) DESC')
      end
    else
      @events = @events.order(:hosted_at)
    end
    
    @events = @events.page(params[:page]).per(10)
    @user_events = current_user&.events&.where("hosted_at > ?", DateTime.now)&.page(params[:user_page]).per(10) if current_user
    render :index
  end

  def archive
    authorize! :archive, Event
    if current_user
      @events = Event.where("hosted_at < ?", DateTime.now).order(:hosted_at)
    end
  end

  def show
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def create
    @event = current_user.events.new(event_params)
    
    @event.tag_list = Array(params[:event][:tag_list]).reject(&:blank?)
    @event.category_list = Array(params[:event][:category_list]).reject(&:blank?)

    unless params[:event][:use_community] == '1'
      @event.community_id = nil
    end

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_path(@event), notice: "Событие создано" }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

    unless params[:event][:use_community] == '1'
      @event.community_id = nil
    end

    @event.tag_list = Array(params[:event][:tag_list]).reject(&:blank?)
    @event.category_list = Array(params[:event][:category_list]).reject(&:blank?)
    
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: "Событие обновлено" }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.destroy!
    respond_to do |format|
      format.html { redirect_to events_path, status: :see_other, notice: "Событие удалено" }
      format.json { head :no_content }
      format.turbo_stream
    end
  end

  def participants
    @event = Event.find(params[:id])
    @participants = @event.responses.includes(user: :profile).order(created_at: :desc).page(params[:page]).per(20)
  end

  private

    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:title, :body, :hosted_at, :cover, :user_id, :community_id, :placed_at, :placed_additional, :price, :ticket_link, tag_list: [], category_list: [])
    end
end