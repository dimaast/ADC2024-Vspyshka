class AddFacultyAndProgramToProfiles < ActiveRecord::Migration[7.2]
  def change
    add_reference :profiles, :faculty, foreign_key: true, null: true
    add_reference :profiles, :program, foreign_key: true, null: true
  end
end

class ChangeReportsToPolymorphic < ActiveRecord::Migration[7.2]
  def change
    add_column :reports, :reportable_type, :string
    add_column :reports, :reportable_id, :integer
    Report.reset_column_information
    # Миграция существующих данных (если есть)
    Report.where.not(event_id: nil).find_each do |report|
      report.update_columns(reportable_type: 'Event', reportable_id: report.event_id)
    end
    remove_column :reports, :event_id
    # Если есть meet_id, аналогично:
    # Report.where.not(meet_id: nil).find_each do |report|
    #   report.update_columns(reportable_type: 'Meet', reportable_id: report.meet_id)
    # end
    # remove_column :reports, :meet_id
  end
end
