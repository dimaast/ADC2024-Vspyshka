class ResponseController < ApplicationController
  before_action :authenticate_user!

  def toggle
    responseable = Object.const_get(params[:type]).find(params[:id])
    responses = responseable.responses.where(user_id: current_user.id)

    if responses && responses.count > 0
      responses.each do |response|
        response.destroy!
      end
    else
      current_user.responses.create!(responseable_type: params[:type], responseable_id: params[:id])
    end

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "response_button_#{responseable.class.name.downcase}_#{responseable.id}",
          partial: "response/button",
          locals: { responseable: responseable }
        )
      }
    end
  end
end
