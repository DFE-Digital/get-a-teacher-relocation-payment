class AddUniquenessToApplicationUrn < ActiveRecord::Migration[7.0]
  def up
    drop_view :duplicate_applications
    add_index(:applications, :urn)
    create_view :duplicate_applications, version: 3
  end

  def down; end
end
