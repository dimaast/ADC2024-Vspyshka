class FavouriteController < ApplicationController
  before_action :authenticate_user!

  def toggle
    @favouriteable = Object.const_get(params[:type]).find(params[:id])
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
