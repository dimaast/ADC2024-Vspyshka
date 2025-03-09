class RemoveEventIdFromComments < ActiveRecord::Migration[7.2]
  def change
    remove_column :comments, :event_id, :integer
  end
end
