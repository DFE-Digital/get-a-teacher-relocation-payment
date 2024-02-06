class Kpis
  def initialize(unit: "hours", range_start: "24", range_end: "0", window: "all")
    @date_range_params = parse_date_range(unit:, range_start:, range_end:)
    @date_range = to_date_range(**@date_range_params)
    @window = window
  end

  attr_reader :date_range, :date_range_params, :window

  def total_applications
    filtered_applications_by_date.count
  end

  def total_rejections
    filter_by_date_range(ApplicationProgress.where.not(rejection_completed_at: nil)).count
  end

  def average_age
    AverageAgeQuery.new(filtered_applications_by_date).call
  end

  def total_paid
    filter_by_date_range(ApplicationProgress.where.not(banking_approval_completed_at: nil)).count
  end

  def route_breakdown
    RouteBreakdownQuery.new(filtered_applications_by_date).call
  end

  def subject_breakdown
    SubjectBreakdownQuery.new(filtered_applications_by_date).call
  end

  def visa_breakdown
    VisaBreakdownQuery.new(filtered_applications_by_date).call.first(3)
  end

  def nationality_breakdown
    NationalityBreakdownQuery.new(filtered_applications_by_date).call.first(5)
  end

  def gender_breakdown
    GenderBreakdownQuery.new(filtered_applications_by_date).call
  end

  def rejection_reason_breakdown
    RejectionReasonBreakdownQuery.new(filtered_applications_by_date).call
  end

  def time_to_initial_checks
    TimeToInitialChecksQuery.new(filtered_progress_by_date).call
  end

  def time_to_home_office_checks
    TimeToHomeOfficeChecksQuery.new(filtered_progress_by_date).call
  end

  def time_to_school_checks
    TimeToSchoolChecksQuery.new(filtered_progress_by_date).call
  end

  def time_to_banking_approval
    TimeToBankingApprovalQuery.new(filtered_progress_by_date).call
  end

  def time_to_payment_confirmation
    TimeToPaymentConfirmationQuery.new(filtered_progress_by_date).call
  end

  def status_breakdown
    StatusBreakdownQuery.call(filtered_progress_by_date)
  end

  def forms_funnel
    forms_funnel_query
  end

  def ineligible_forms_funnel
    forms_funnel_query.select { |_, hsh| hsh.fetch(:ineligible, nil) }
  end

  def funnel_date_range_title
    return funnel_title_last_n if date_range_params.fetch(:range_end).zero?

    [
      "between",
      date_range_params.fetch(:range_start),
      "and",
      date_range_params.fetch(:range_end),
      date_range_params.fetch(:unit),
      "ago",
    ].join(" ")
  end

private

  def funnel_title_last_n
    ["last", date_range_params.fetch(:range_start), date_range_params.fetch(:unit)].join(" ")
  end

  def parse_date_range(unit:, range_start:, range_end:)
    raise(ArgumentError, "invalid unit value, must be hours or days") unless %w[hours days].include?(unit)

    range_end = range_end.to_i
    range_start = range_start.to_i

    raise(ArgumentError, "range_end and range_start must be positive numbers") if range_start.negative? || range_end.negative?
    raise(ArgumentError, "range_end must be lower than range_start") if range_end >= range_start

    { unit:, range_start:, range_end: }
  end

  def to_date_range(unit:, range_start:, range_end:)
    Range.new(
      range_start.public_send(unit).ago,
      range_end.public_send(unit).ago,
    )
  end

  def forms_funnel_query
    @forms_funnel_query ||= FormsFunnelQuery.call(date_range:)
  end

  def date_ranges
    {
      "sept_oct" => Date.new(2023, 9, 1).beginning_of_day..Date.new(2023, 10, 31).end_of_day,
      "jan_feb" => Date.new(2024, 1, 1).beginning_of_day..Date.new(2024, 3, 1).end_of_day,
    }
  end

  def filter_by_date_range(scope)
    if date_ranges.key?(window)
      scope.where(created_at: date_ranges[window])
    else
      scope
    end
  end

  def filtered_applications_by_date
    filter_by_date_range(Application.all)
  end

  def filtered_progress_by_date
    filter_by_date_range(ApplicationProgress.all)
  end
end
