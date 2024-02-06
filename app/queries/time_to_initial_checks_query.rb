class TimeToInitialChecksQuery
  include InflectionHelper

  def initialize(relation = ApplicationProgress.all)
    @relation = relation
  end

  def call
    applications_list = @relation.where.not(created_at: nil).where.not(initial_checks_completed_at: nil)
    durations = applications_list.map { |app| (app.initial_checks_completed_at.to_date - app.created_at.to_date).to_i }
    calculate_day_stats(durations)
  end
end
