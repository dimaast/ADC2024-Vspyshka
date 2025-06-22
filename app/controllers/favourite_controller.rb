class FavouriteController < ApplicationController
  before_action :authenticate_user!

  def toggle
    begin
      @favouriteable = Object.const_get(params[:type]).find(params[:id])
    rescue ActiveRecord::RecordNotFound, NameError
      respond_to do |format|
        format.turbo_stream { render partial: "shared/flash", locals: { message: "Ошибка: объект не найден" }, status: :not_found }
        format.html { redirect_back fallback_location: root_path, alert: "Ошибка: объект не найден" }
      end
      return
    end
    favourites = @favouriteable.favourites.where(user_id: current_user.id)

    if favourites.exists?
      favourites.destroy_all
    else
      current_user.favourites.create!(favouriteable_type: params[:type], favouriteable_id: params[:id])
    end

    respond_to do |format|
      format.turbo_stream { render template: "meets/toggle" }
    end
  end
end
