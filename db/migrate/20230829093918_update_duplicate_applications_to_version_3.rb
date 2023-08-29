class UpdateDuplicateApplicationsToVersion3 < ActiveRecord::Migration[7.0]
  def change
    update_view :duplicate_applications, version: 3, revert_to_version: 2
  end
end
