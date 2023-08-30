class CreateNewQaStatusesTable < ActiveRecord::Migration[7.0]
  def change
    create_table(:qa_statuses) do |t|
      t.references(:application, foreign_key: true)
      t.string(:status)
      t.date(:date)

      t.timestamps
    end
    add_index(:qa_statuses, %i[application_id status], unique: true)
  end
end
