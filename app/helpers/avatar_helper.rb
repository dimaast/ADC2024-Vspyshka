module AvatarHelper
  def user_avatar(user, class_name: "", size: 52)
    if user&.profile&.avatar&.present?
      image_tag user.profile.avatar.url, class: class_name, alt: user.username, width: size, height: size
    else

      username = user&.username || "?"

      avatars_dir = Rails.root.join('app', 'assets', 'images', 'avatars')
      avatar_files = Dir.glob(File.join(avatars_dir, '*.{jpg,jpeg,png,webp}'))
      
      if avatar_files.any? && user&.id

        random_seed = user.id * 31 + 123
        random_index = random_seed % avatar_files.length
        selected_avatar = File.basename(avatar_files[random_index])
        avatar_path = "avatars/#{selected_avatar}"
        
        image_tag avatar_path, class: class_name, alt: username, width: size, height: size
      else

        content_tag :div, 
          class: "#{class_name} avatar-placeholder", 
          style: "width: #{size}px; height: #{size}px; background-color: #CCCCCC; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: #{size/2}px; color: #ffffff; font-weight: bold;",
          title: username do
          "?"
        end
      end
    end
  end
end