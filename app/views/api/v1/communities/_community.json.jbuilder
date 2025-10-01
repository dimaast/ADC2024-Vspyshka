json.extract! community, :id, :title, :body, :user_id, :cover, :contact, :created_at, :updated_at
json.tags community.tag_list
json.url community_url(community)
json.subscribers_count community.subscriptions.count
json.events_count community.events.count
json.creator do
  if community.user
    json.id community.user.id
    json.username community.user.username
    json.first_name community.user.first_name
    json.last_name community.user.last_name
  else
    json.null!
  end
end
