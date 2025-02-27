class CreateCommunities < ActiveRecord::Migration[7.2]
  def change
    create_table :communities do |t|
      t.string :title
      t.text :body
      t.references :user, null: false, foreign_key: true
      t.string :cover
      t.string :link

      t.timestamps
    end
  end
end
