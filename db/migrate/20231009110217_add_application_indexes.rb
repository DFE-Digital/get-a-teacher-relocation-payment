class AddApplicationIndexes < ActiveRecord::Migration[7.0]
  def change
    drop_table :urns # rubocop:disable Rails/ReversibleMigration
    add_index :applications, :urn, unique: true
    add_index :applications, :application_route
  end
end
