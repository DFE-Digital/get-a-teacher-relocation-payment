class AddMiddleNameToApplicant < ActiveRecord::Migration[7.0]
  def change
    add_column :applicants, :middle_name, :string
  end
end
