class AddFacultyAndProgramToProfiles < ActiveRecord::Migration[7.2]
  def change
    add_reference :profiles, :faculty, foreign_key: true, null: true
    add_reference :profiles, :program, foreign_key: true, null: true

  end
end
