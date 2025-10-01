class AddTicketLinkToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :ticket_link, :string
  end
end
