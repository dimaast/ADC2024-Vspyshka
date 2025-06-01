module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      Rails.logger.debug "[ActionCable] raw cookies: #{cookies.to_hash.inspect}"
      Rails.logger.debug "[ActionCable] encrypted[:user_id] = #{cookies.encrypted[:user_id].inspect}"
      self.current_user = find_verified_user
      Rails.logger.debug "[ActionCable] current_user = #{current_user.inspect}"
    end

    private

    def find_verified_user
      if (verified_user = User.find_by(id: cookies.encrypted[:user_id]))
        Rails.logger.debug "[ActionCable] нашли пользователя через cookies.encrypted[:user_id]: #{verified_user.id}"
        verified_user
      else
        Rails.logger.debug "[ActionCable] не нашли user_id в cookies.encrypted, reject_unauthorized_connection"
        reject_unauthorized_connection
      end
    end
  end
end
