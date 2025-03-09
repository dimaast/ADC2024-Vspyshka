class Admin::CommunitiesController < ApplicationController
  load_and_authorize_resource
  before_action :set_community, only: %i[ update destroy ]

  # GET /communities or /communities.json
  def index
    if current_user&.role == "admin"
      @communities = Community.all
    else
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end

  # GET /communities/new
  def new
    @community = Community.new
  end

  # POST /communities or /communities.json
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

  # PATCH/PUT /communities/1 or /communities/1.json
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

  # DELETE /communities/1 or /communities/1.json
  def destroy
    @community.destroy!

    respond_to do |format|
      format.html { redirect_to communities_path, status: :see_other, notice: "Community was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community
      @community = Community.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def community_params
      params.require(:community).permit(:title, :body, :user_id, :cover, :link)
    end
end
