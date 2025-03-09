class FavouriteController < ApplicationController
  before_action :authenticate_user!

  def toggle
    favouriteable = Object.const_get(params[:type]).find(params[:id])
    favourites = favouriteable.favourites.where(user_id: current_user.id)

    if favourites && favourites.count > 0
      favourites.each do |favourite|
        favourite.destroy!
      end
    else
      current_user.favourites.create!(favouriteable_type: params[:type], favouriteable_id: params[:id])
    end
  end
end
