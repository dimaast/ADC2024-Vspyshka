class AddPriceToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :price, :string
  end
end
