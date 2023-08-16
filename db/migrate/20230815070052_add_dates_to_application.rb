class AddDatesToApplication < ActiveRecord::Migration[7.0]
  def change
    add_column(:applications, :home_office_csv_downloaded_at, :datetime)
    add_column(:applications, :standing_data_csv_downloaded_at, :datetime)
    add_column(:applications, :payroll_csv_downloaded_at, :datetime)
  end
end
