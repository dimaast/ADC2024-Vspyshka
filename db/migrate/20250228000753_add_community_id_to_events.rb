class AddCommunityIdToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :community_id, :integer
  end
end
