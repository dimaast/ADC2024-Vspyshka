class MeetsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  load_and_authorize_resource except: [ :index, :show ]
  before_action :set_meet, only: %i[ show edit update destroy ]

  def index
    @meets = Meet.all

    if params[:place].present?
      @meets = @meets.where(placed_at: params[:place])
    end

    if params[:date].present?
      date = Date.parse(params[:date])
      @meets = @meets.where(hosted_at: date.beginning_of_day..date.end_of_day)
    end

    case params[:sort]
    when 'popular'
      @meets = @meets.joins(:responses).group('meets.id').order('COUNT(responses.id) DESC')
    when 'new'
      @meets = @meets.order(created_at: :desc)
    else
      @meets = @meets.order(created_at: :desc) # По умолчанию сортируем по дате создания
    end
    
    @meets = @meets.page(params[:page]).per(10)
  end

  def by_tag
    @meets = Meet.tagged_with(params[:tag]).page(params[:page]).per(10)
    render :index
  end

  def show
  end

  def new
    @meet = Meet.new
  end

  def edit
  end

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

  def destroy
    @meet.destroy!
    respond_to do |format|
      format.html { redirect_to meets_path, status: :see_other, notice: "Meet was successfully destroyed." }
      format.json { head :no_content }
      format.turbo_stream
    end
  end

  def participants
    @meet = Meet.find(params[:id])
    @participants = @meet.responses.includes(user: :profile).order(created_at: :desc).page(params[:page]).per(20)
  end

  private

    def set_meet
      @meet = Meet.find(params[:id])
    end

    def meet_params
      params.require(:meet).permit(:body, :hosted_at, :user_id, tag_list: [])
    end
end