class CreateFavourites < ActiveRecord::Migration[7.2]
  def change
    create_table :favourites do |t|
      t.string :favouriteable_type
      t.integer :favouriteable_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
