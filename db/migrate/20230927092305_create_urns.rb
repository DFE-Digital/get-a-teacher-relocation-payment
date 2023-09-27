class CreateUrns < ActiveRecord::Migration[7.0]
  def change
    create_table :urns do |t|
      t.string :prefix
      t.string :code
      t.integer :suffix

      t.timestamps
    end
    add_index :urns, :code
  end
end
