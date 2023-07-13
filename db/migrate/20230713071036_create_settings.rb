class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.date :service_start_date
      t.date :service_end_date

      t.timestamps
    end
  end
end
