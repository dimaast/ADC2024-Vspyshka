class AddPlaceFieldsToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :placed_at, :string
    add_column :events, :placed_additional, :string
  end
end
