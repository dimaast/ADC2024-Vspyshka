module ProfilesHelper
  # Генерирует CSS-градиент на основе id пользователя
  def avatar_placeholder_style(user)
    id = user.id || 0
    # Простейший хэш: два цвета из id
    color1 = "##{Digest::MD5.hexdigest((id * 31).to_s)[0..5]}"
    color2 = "##{Digest::MD5.hexdigest((id * 97 + 123).to_s)[6..11]}"
    "background: radial-gradient(circle at 60% 40%, #{color1}, #{color2});"
  end
end
