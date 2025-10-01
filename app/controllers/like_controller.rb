class LikeController < ApplicationController
  before_action :authenticate_user!

  def toggle
    likeable = Object.const_get(params[:type]).find(params[:id])
    like = likeable.likes.find_by(user_id: current_user.id)
    if like
      like.destroy!
    else
      likeable.likes.create!(user: current_user)
    end
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(view_context.dom_id(likeable), partial: 'comments/comment', locals: { comment: likeable }) }
      format.html { redirect_back fallback_location: root_path }
    end
  end
end