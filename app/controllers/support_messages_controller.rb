class SupportMessagesController < ApplicationController
  before_action :authenticate_user!   

  def create
    message_text = params[:message]

    SupportMessage.create!(
        user: current_user,
        body: message_text
    )

    flash[:notice] = "Ваше сообщение отправлено. Спасибо!"
    redirect_to settings_path(anchor: "settings-support")
  end
end