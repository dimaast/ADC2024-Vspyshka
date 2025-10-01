class CommentsController < ApplicationController
  load_and_authorize_resource
  before_action :set_commentable_type, only: %i[create update destroy new]
  before_action :set_comment, only: %i[show edit update]

  def index
    @comments = Comment.all
  end

  def show
  end

  def new
    @comment = Comment.new
  end

  def edit
    @commentable = @comment.commentable
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save

        if @comment.user.id != @commentable.user.id
          user = @commentable.user
          body = "Комментарий \"#{@comment.body}\" от пользователя #{current_user.email}"
          url = polymorphic_url(@commentable, anchor: "comment_#{@comment.id}")
          
          notification = user.notifications.create!(
            body:    body,
            comment: @comment,
            read:    false,
            url:     url,
            notificationable: @commentable
          )
          
          ActionCable.server.broadcast(
            "notifications_#{user.id}",
            {
              body: body,
              url:  url
            }
          )
        end

        format.html { redirect_to @comment.commentable, notice: "Comment was successfully created." }
        format.json { render :show, status: :created, location: @comment }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end

    end

  end

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

  def destroy
    @comment = @commentable.comments.find(params[:id])
    @comment.destroy!

    respond_to do |format|
      format.html { redirect_to @comment.commentable, status: :see_other, notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
      format.turbo_stream
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_commentable_type
    if params[:event_id]
      @commentable = Event.find(params[:event_id])
    elsif params[:meet_id]
      @commentable = Meet.find(params[:meet_id])
    end
  end

  def comment_params
    params.require(:comment).permit(:body, :comment_id, :commentable_type, :commentable_id)
  end
end