class InterestsController < ApplicationController
  before_action :authenticate_user!

  def choose
    @tags = Tag.tags_list.order("RANDOM()")
    @selected_tags = current_user.tag_list
  end

  def save
    selected_tags = params[:tags] || []
    current_user.tag_list = selected_tags
    current_user.save
    redirect_to profile_path(current_user.profile), notice: "Интересы сохранены!"
  end
end