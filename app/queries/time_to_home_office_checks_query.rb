class TimeToHomeOfficeChecksQuery
  include InflectionHelper

  def initialize(relation = ApplicationProgress.all)
    @relation = relation
  end

  def call
    applications_list = @relation.where.not(initial_checks_completed_at: nil).where.not(home_office_checks_completed_at: nil)
    durations = applications_list.map { |app| (app.home_office_checks_completed_at.to_date - app.initial_checks_completed_at.to_date).to_i }
    calculate_day_stats(durations)
  end
end
