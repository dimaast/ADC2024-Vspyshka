class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :comment_id
      t.string :body

      t.timestamps
    end
  end
end
