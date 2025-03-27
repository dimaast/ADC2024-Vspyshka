class Api::V1::MeetsController < ApplicationController
  def index
    @meets = Meet.all
  end

  def show
    @meet = Meet.find(params[:id])
  end
end
