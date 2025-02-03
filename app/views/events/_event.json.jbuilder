json.extract! event, :id, :title, :body, :created_at, :updated_at
json.url event_url(event, format: :json)
