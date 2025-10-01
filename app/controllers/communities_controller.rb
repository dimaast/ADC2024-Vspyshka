class CommunitiesController < ApplicationController
  load_and_authorize_resource except: [ :index, :show, :by_tag ]
  before_action :set_community, only: %i[ show edit update ]

  def index
    @communities = Community.all
    @tags = Tag.tags_list
  end

  def show
    @events_filter = params[:events_filter] || 'current'
    
    if @events_filter == 'archive'
      @events = @community.events.where('hosted_at < ?', Date.current)
    else
      @events = @community.events.where('hosted_at >= ?', Date.current)
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @community.update(community_params)
        format.html { redirect_to @community, notice: "Community was successfully updated." }
        format.json { render :show, status: :ok, location: @community }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @community.errors, status: :unprocessable_entity }
      end
    end
  end

  def by_tag
    @tag = params[:tag]
    @communities = Community.tagged_with(@tag)
    @tags = Tag.tags_list
    
    respond_to do |format|
      format.html { render :index }
      format.turbo_stream
    end
  end

  def subscribers
    @community = Community.find(params[:id])
    @subscribers = User.joins(:subscriptions).where(subscriptions: { subscriptionable_type: 'Community', subscriptionable_id: @community.id })
  end

  private

    def set_community
      @community = Community.find(params[:id])
    end

    def community_params
      params.require(:community).permit(:body, :cover, :link)
    end
end