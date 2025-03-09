class CreateSubscriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :subscriptions do |t|
      t.string :subscriptionable_type
      t.integer :subscriptionable_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
