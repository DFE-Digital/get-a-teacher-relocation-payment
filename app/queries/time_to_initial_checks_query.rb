class TimeToInitialChecksQuery
  include InflectionHelper

  def initialize(relation = ApplicationProgress.all)
    @relation = relation
  end

  def call
    applications_list = @relation.where.not(created_at: nil).where.not(initial_checks_completed_at: nil)

    durations    = applications_list.map { |app| (app.initial_checks_completed_at.to_date - app.created_at.to_date).to_i }

    min_days     = pluralize_word(durations.min.abs, "day") if durations.min
    max_days     = pluralize_word(durations.max.abs, "day") if durations.max
    average_duration = durations.size.positive? ? (durations.sum / durations.size.to_f).round.abs : 0
    average_days = pluralize_word(average_duration, "day")

    { min: min_days, max: max_days, average: average_days }
  end
end
