class RenameTypeToTagTypeInTags < ActiveRecord::Migration[7.2]
  def change
    rename_column :tags, :type, :tag_type
  end
end
