class AddCommentableIdToComment < ActiveRecord::Migration[7.2]
  def change
    add_column :comments, :commentable_id, :integer
  end
end
