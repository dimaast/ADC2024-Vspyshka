class MeetsController < ApplicationController
  load_and_authorize_resource
  before_action :set_meet, only: %i[ show edit update destroy ]

  # GET /meets or /meets.json
  def index
    @meets = Meet.all
  end

  def by_tag
    @meets = Meet.tagged_with(params[:tag])
    render :index
  end

  # GET /meets/1 or /meets/1.json
  def show
  end

  # GET /meets/new
  def new
    @meet = Meet.new
  end

  # GET /meets/1/edit
  def edit
  end

  # POST /meets or /meets.json
  def create
    @meet = current_user.meets.new(meet_params)
    @meet.tag_list = params[:meet][:tag_list].to_a.reject(&:blank?)

    respond_to do |format|
      if @meet.save
        format.html { redirect_to meet_path(@meet), notice: "Meet was successfully created." }
        format.json { render :show, status: :created, location: @meet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @meet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meets/1 or /meets/1.json
  def update
    respond_to do |format|
      if @meet.update(meet_params)
        format.html { redirect_to @meet, notice: "Meet was successfully updated." }
        format.json { render :show, status: :ok, location: @meet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @meet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meets/1 or /meets/1.json
  def destroy
    @meet.destroy!

    respond_to do |format|
      format.html { redirect_to meets_path, status: :see_other, notice: "Meet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meet
      @meet = Meet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def meet_params
      params.require(:meet).permit(:body, :hosted_at, :user_id, tag_list: [])
    end
end
