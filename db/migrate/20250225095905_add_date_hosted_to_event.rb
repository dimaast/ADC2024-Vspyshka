class AddDateHostedToEvent < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :hosted_at, :datetime, null: false
  end
end
