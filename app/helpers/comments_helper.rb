module CommentsHelper
  def count_replies(comment)
    total_replies = comment.replies.count
    comment.replies.each do |reply|
      total_replies += count_replies(reply) # Recursively count nested replies
    end
    total_replies
  end
end
