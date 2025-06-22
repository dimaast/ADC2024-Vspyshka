class AddPlacedAtToMeets < ActiveRecord::Migration[7.2]
  def change
    add_column :meets, :placed_at, :string
  end
end
