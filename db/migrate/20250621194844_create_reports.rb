class CreateReports < ActiveRecord::Migration[7.2]
  def change
    create_table :reports do |t|
      t.text :reason
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
