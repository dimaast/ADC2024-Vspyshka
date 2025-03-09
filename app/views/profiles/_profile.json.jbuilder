json.extract! profile, :id, :name, :body, :contact, :avatar, :user_id, :created_at, :updated_at
json.url profile_url(profile, format: :json)
