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

      if ["Event", "Meet"].include?(params[:type])
        responseable_user = responseable.user

        unless responseable_user == current_user
          title = params[:type] == "Event" ? responseable.title : responseable.body.truncate(30)
          body = "Пользователь #{current_user.username} зарегистрировался на ваше " + (params[:type] == "Event" ? "событие" : "встречу") + ": '#{title}'"
          url = params[:type] == "Event" ? Rails.application.routes.url_helpers.event_path(responseable) : Rails.application.routes.url_helpers.meet_path(responseable)
          
          notification = responseable_user.notifications.create!(
            body: body,
            comment: nil,
            read: false,
            url: url,
            notificationable: responseable
          )
          
          ActionCable.server.broadcast(
            "notifications_#{responseable_user.id}",
            {
              body: body,
              url: url
            }
          )
        end
      end
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