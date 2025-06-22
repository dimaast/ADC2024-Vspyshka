class SyncUserProfileData < ActiveRecord::Migration[7.2]
  def up
    # Синхронизируем данные из users в profiles
    User.joins(:profile).find_each do |user|
      user.profile.update_columns(
        first_name: user.first_name,
        last_name: user.last_name,
        middle_name: user.middle_name
      )
    end
  end

  def down
    # Откат не требуется, так как мы только копируем данные
  end
end
