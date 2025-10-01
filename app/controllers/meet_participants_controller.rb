class MeetParticipantsController < ApplicationController
  before_action :set_meet
  before_action :authenticate_user!

  def index
    @participants = @meet.responses.includes(:user).order(created_at: :desc)
  end

  private

  def set_meet
    @meet = Meet.find(params[:meet_id])
  end
end