module ProfilesHelper

  def avatar_placeholder_style(user)

    if user.nil? || user.id.nil? || user.id == 0
      return "background-color: #CCCCCC;"
    end

    avatars_dir = Rails.root.join('app', 'assets', 'images', 'avatars')
    avatar_files = Dir.glob(File.join(avatars_dir, '*.{jpg,jpeg,png,webp}'))

    if avatar_files.empty?
      return "background-color: #CCCCCC;"
    end

    random_seed = user.id * 31 + 123
    random_index = random_seed % avatar_files.length
    selected_avatar = File.basename(avatar_files[random_index])
    avatar_path = "avatars/#{selected_avatar}"
    
    "background-image: url('#{asset_path(avatar_path)}'); background-size: cover; background-position: center;"
  end
end