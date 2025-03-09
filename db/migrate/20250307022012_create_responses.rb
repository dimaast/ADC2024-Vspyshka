class CreateResponses < ActiveRecord::Migration[7.2]
  def change
    create_table :responses do |t|
      t.string :responseable_type
      t.integer :responseable_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
