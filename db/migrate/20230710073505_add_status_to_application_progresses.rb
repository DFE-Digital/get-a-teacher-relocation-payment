class AddStatusToApplicationProgresses < ActiveRecord::Migration[7.0]
  def up
    add_column(:application_progresses, :status, :integer, default: 0)
    ApplicationProgress.reset_column_information # This makes the new column available to ActiveRecord immediately
    ApplicationProgress.find_each(&:save!) # Trigger the before save callbacks
  end

  def down
    remove_column(:application_progresses, :status)
  end
end
