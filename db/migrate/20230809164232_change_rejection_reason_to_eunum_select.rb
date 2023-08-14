class ChangeRejectionReasonToEunumSelect < ActiveRecord::Migration[7.0]
  def change
    # Rename the rejection_reason column to rejection_details
    rename_column(:application_progresses, :rejection_reason, :rejection_details)

    # Add a new rejection_reason column of type integer with default as nil
    add_column(:application_progresses, :rejection_reason, :integer, default: nil)
  end
end
