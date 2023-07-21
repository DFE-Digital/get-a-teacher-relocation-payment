class EnableOpeningTimes < ActiveRecord::Migration[7.0]
  def change
    AppSettings.current.update!(
      service_start_date: Time.zone.yesterday,
      service_end_date: Time.zone.today + 1.year,
    )
  end
end
