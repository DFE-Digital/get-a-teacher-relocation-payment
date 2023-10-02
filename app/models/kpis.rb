class Kpis
  def initialize(unit: "hours", range_start: "24", range_end: "0")
    @date_range_params = parse_date_range(unit:, range_start:, range_end:)
    @date_range = to_date_range(**@date_range_params)
  end

  attr_reader :date_range, :date_range_params

  def total_applications
    Application.count
  end

  def total_rejections
    ApplicationProgress.where.not(rejection_completed_at: nil).count
  end

  def average_age
    AverageAgeQuery.new.call
  end

  def total_paid
    ApplicationProgress.where.not(banking_approval_completed_at: nil).count
  end

  def route_breakdown
    RouteBreakdownQuery.new.call
  end

  def subject_breakdown
    SubjectBreakdownQuery.new.call
  end

  def visa_breakdown
    VisaBreakdownQuery.new.call.first(3)
  end

  def nationality_breakdown
    NationalityBreakdownQuery.new.call.first(5)
  end

  def gender_breakdown
    GenderBreakdownQuery.new.call
  end

  def rejection_reason_breakdown
    RejectionReasonBreakdownQuery.new.call
  end

  def time_to_initial_checks
    TimeToInitialChecksQuery.new.call
  end

  def time_to_home_office_checks
    TimeToHomeOfficeChecksQuery.new.call
  end

  def time_to_school_checks
    TimeToSchoolChecksQuery.new.call
  end

  def time_to_banking_approval
    TimeToBankingApprovalQuery.new.call
  end

  def time_to_payment_confirmation
    TimeToPaymentConfirmationQuery.new.call
  end

  def status_breakdown
    StatusBreakdownQuery.call
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
end
