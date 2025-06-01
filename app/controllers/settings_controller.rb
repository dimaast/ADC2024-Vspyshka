class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile

  # GET /settings
  def index
    # Просто отрисовать страницу settings/index.html.erb
  end

  # PATCH /settings
  def update
    if @profile.update(profile_params)
      redirect_to settings_path, notice: "Настройки успешно сохранены"
    else
      flash.now[:alert] = "Не удалось сохранить настройки"
      render :index
    end
  end

  private

  def set_profile
    @profile = current_user.profile
  end

  def profile_params
    # Добавляем сюда все поля, которые можем править, включая :faculty_id и :program_id
    params.require(:profile).permit(
      :first_name,
      :last_name,
      :avatar,
      :telegram_handle,
      :faculty_id,
      :program_id
    )
  end
end
