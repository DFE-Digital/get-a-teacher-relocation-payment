# Initially created to help display the correct form of day or days in the dashboard.
module InflectionHelper
  def pluralize_word(count, word)
    "#{count} #{word.pluralize(count)}"
  end

  def calculate_day_stats(durations)
    min_days         = pluralize_word(durations.min.abs, "day") if durations.min
    max_days         = pluralize_word(durations.max.abs, "day") if durations.max
    average_duration = durations.size.positive? ? (durations.sum / durations.size.to_f).round.abs : 0
    average_days     = pluralize_word(average_duration, "day")

    { min: min_days, max: max_days, average: average_days }
  end
end
