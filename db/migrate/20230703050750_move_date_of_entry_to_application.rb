class MoveDateOfEntryToApplication < ActiveRecord::Migration[7.0]
  def change
    add_column :applications, :date_of_entry, :date
  end
end
