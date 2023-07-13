class RenameSettingsToAppSettings < ActiveRecord::Migration[7.0]
  def change
    rename_table :settings, :app_settings
  end
end
