class EventsController < ApplicationController
  # before_action :authenticate_user!
  # layout "application", only: %i[ show new edit create update destroy ]
  load_and_authorize_resource
  before_action :set_event, only: %i[ show edit update destroy ]

  # GET /events or /events.json
  def index
    @categories = Tag.categories_list
    @tags = Tag.tags_list

    if current_user
      @user_events = current_user.events.where("hosted_at > ?", DateTime.now)
      @events = Event.where("hosted_at > ?", DateTime.now).order(:hosted_at)
    end
  end

  def by_tag
    @categories = Tag.categories_list
    @tags = Tag.tags_list

    @category = params[:category]
    @tag = params[:tag]

    @events = Event.where("hosted_at > ?", DateTime.now)

    # Фильтрация по категории (типу события)
    @events = @events.tagged_with(@category, on: :categories) if @category.present?

    # Фильтрация по тегу
    @events = @events.tagged_with(@tag, on: :tags) if @tag.present?

    @events = @events.order(:hosted_at)

    render :index
  end

  def archive
    authorize! :archive, Event
    if current_user
      @events = Event.where("hosted_at < ?", DateTime.now).order(:hosted_at)
    end
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = current_user.events.new(event_params)
    @event.tag_list = params[:event][:tag_list].to_a.reject(&:blank?)

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

  # PATCH/PUT /events/1 or /events/1.json
  def update
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

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy!

    respond_to do |format|
      format.html { redirect_to events_path, status: :see_other, notice: "Событие удалено" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:title, :body, :hosted_at, :cover, :user_id, :community_id, :placed_at, :placed_additional, tag_list: [], category_list: [])
    end
end
