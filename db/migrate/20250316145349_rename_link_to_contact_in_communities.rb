class RenameLinkToContactInCommunities < ActiveRecord::Migration[7.2]
  def change
    rename_column :communities, :link, :contact
  end
end
