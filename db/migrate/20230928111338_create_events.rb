class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :action
      t.string :entity_class
      t.integer :entity_id
      t.jsonb :data

      t.timestamps
    end
    add_index :events, :entity_class
  end
end
