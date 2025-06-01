# app/controllers/support_messages_controller.rb
class SupportMessagesController < ApplicationController
  before_action :authenticate_user!   # если вы используете Devise / аутентификацию
  # (уберите, если не нужно)

  # POST /support_messages
  def create
    # Извлекаем текст сообщения из params[:message]:
    message_text = params[:message]

    # Здесь вы можете либо:
    #   1) Сохранить его в базе (через модель SupportMessage),
    #   2) Отправить письмо на почту админов,
    #   3) Просто слить это в лог и вернуть успешный статус.
    #
    # Ниже приведён пример “минимальной” реализации, которая просто пишет в лог,
    # а потом делает редирект обратно на страницу настроек с флешем:

    SupportMessage.create!(
        user: current_user,
        body: message_text
    )

    # Если хотите, создайте модель:
    #   SupportMessage.create!(user: current_user, body: message_text)
    #
    # Или отправьте почту:
    #   SupportMailer.with(user: current_user, body: message_text).notify_admin.deliver_later

    flash[:notice] = "Ваше сообщение отправлено. Спасибо!"
    # Возвращаем пользователя обратно на страницу настроек, например так:
    redirect_to settings_path(anchor: "settings-support")
  end
end
