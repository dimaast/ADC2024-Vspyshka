class Api::V1::EventsController < ApplicationController
  # GET /events or /events.json
  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end
end
