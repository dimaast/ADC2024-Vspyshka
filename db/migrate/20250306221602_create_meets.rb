class CreateMeets < ActiveRecord::Migration[7.2]
  def change
    create_table :meets do |t|
      t.text :body
      t.datetime :hosted_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
