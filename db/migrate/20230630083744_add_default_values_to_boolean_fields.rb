class AddDefaultValuesToBooleanFields < ActiveRecord::Migration[7.0]
  def up
    execute('UPDATE application_progresses
      SET visa_investigation_required = false
      WHERE visa_investigation_required != true')

    change_column :application_progresses, :visa_investigation_required, :boolean, default: false, null: false
    execute('UPDATE application_progresses
      SET school_investigation_required = false
      WHERE school_investigation_required != true')

    change_column :application_progresses, :school_investigation_required, :boolean, default: false, null: false
  end
end
