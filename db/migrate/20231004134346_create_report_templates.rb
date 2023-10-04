class CreateReportTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :report_templates do |t|
      t.string :report_class
      t.string :filename
      t.binary :file
      t.jsonb :config

      t.timestamps
    end

    add_index :report_templates, :report_class, unique: true
  end
end
