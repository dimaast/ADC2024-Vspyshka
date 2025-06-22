class AddPersonalInfoToProfiles < ActiveRecord::Migration[7.2]
  def change
    add_column :profiles, :first_name, :string
    add_column :profiles, :last_name, :string
    add_column :profiles, :middle_name, :string
  end
end
