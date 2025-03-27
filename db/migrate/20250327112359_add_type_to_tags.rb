class AddTypeToTags < ActiveRecord::Migration[7.2]
  def change
    add_column :tags, :type, :string
  end
end
