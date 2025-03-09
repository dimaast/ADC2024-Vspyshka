class AddCommentableTypeToComment < ActiveRecord::Migration[7.2]
  def change
    add_column :comments, :commentable_type, :string
  end
end
