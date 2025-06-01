# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
  load_and_authorize_resource
  before_action :set_commentable_type, only: %i[create update destroy new]
  before_action :set_comment, only: %i[show edit update]

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
    @commentable = @comment.commentable
  end

  # POST /comments or /comments.json
  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        # Если автор комментария и автор ресурса — разные люди,
        # то создаём уведомление и трансмитим его через ActionCable.
        if @comment.user.id != @commentable.user.id
          user = @commentable.user
          body = "Комментарий \"#{@comment.body}\" от пользователя #{current_user.email}"
          notification = user.notifications.create!(
            body:    body,
            comment: @comment,
            read:    false
          )
          ActionCable.server.broadcast(
            "notifications_#{user.id}",
            {
              body: body,
              url:  event_path(@commentable, anchor: "comment_#{@comment.id}")
            }
          )
        end
        # ↑↑↑ здесь закрывается if @comment.user.id != @commentable.user.id ↑↑↑

        format.html { redirect_to @comment.commentable, notice: "Comment was successfully created." }
        format.json { render :show, status: :created, location: @comment }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
      # ↑↑↑ здесь закрывается if @comment.save … else … end ↑↑↑
    end
    # ↑↑↑ здесь закрывается respond_to … end ↑↑↑
  end
  # ↑↑↑ здесь закрывается метод create ↑↑↑

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment.commentable, notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment = @commentable.comments.find(params[:id])
    @comment.destroy!

    respond_to do |format|
      format.html { redirect_to @comment.commentable, status: :see_other, notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Находит комментарий по переданному params[:id]
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Определяет родительский объект (Event или Meet)
  def set_commentable_type
    if params[:event_id]
      @commentable = Event.find(params[:event_id])
    elsif params[:meet_id]
      @commentable = Meet.find(params[:meet_id])
    end
  end

  # Разрешённые параметры
  def comment_params
    params.require(:comment).permit(:body, :comment_id, :commentable_type, :commentable_id)
  end
end
