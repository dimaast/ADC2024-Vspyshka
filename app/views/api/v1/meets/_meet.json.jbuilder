json.extract! meet, :id, :body, :hosted_at, :user_id, :created_at, :updated_at, :placed_at
json.tags meet.tag_list
json.url meet_url(meet)
