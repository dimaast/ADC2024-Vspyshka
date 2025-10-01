class Admin::CommunitiesController < ApplicationController
  load_and_authorize_resource
  before_action :set_community, only: %i[ update destroy ]

  def index
    if current_user&.role == "admin"
      @communities = Community.all
    else
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end

  def new
    @community = Community.new
  end

  def create
    @community = Community.new(community_params)

    respond_to do |format|
      if @community.save
        format.html { redirect_to @community, notice: "Community was successfully created." }
        format.json { render :show, status: :created, location: @community }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @community.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @community.update(community_params)
        format.html { redirect_to @community, notice: "Community was successfully updated." }
        format.json { render :show, status: :ok, location: @community }
      else
        format.html { render "communities/edit", status: :unprocessable_entity }
        format.json { render json: @community.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @community.destroy!

    respond_to do |format|
      format.html { redirect_to communities_path, status: :see_other, notice: "Community was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_community
      @community = Community.find(params[:id])
    end

    def community_params
      params.require(:community).permit(:title, :body, :user_id, :cover, :link)
    end
end