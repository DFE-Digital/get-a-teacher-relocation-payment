class Kpis
  def initialize
    @applications = Applicant.all
  end

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
end
