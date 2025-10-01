json.extract! event, :id, :title, :body, :created_at, :updated_at, :cover, :hosted_at, :user_id, :community_id, :placed_at, :placed_additional, :price
json.tags event.tag_list
json.categories event.category_list
json.url event_url(event)
