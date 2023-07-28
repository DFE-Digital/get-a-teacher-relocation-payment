class SlaChecker
  SLA_TIMES = {
    created_at: 2,
    initial_checks_completed_at: 3,
    home_office_checks_completed_at: 5,
    school_checks_completed_at: 15,
  }.freeze

  def initialize(application_progress)
    @application_progress = application_progress
  end

  def breached?
    return false if already_processed?

    latest_date_field = latest_completed_field

    sla_time = SLA_TIMES[latest_date_field]
    completion_date = @application_progress.send(latest_date_field)

    completion_date && completion_date < sla_time.days.ago
  end

private

  def latest_completed_field
    # Checks the fields in reverse order and returns the first one that is present
    SLA_TIMES.keys.reverse.find { |field| @application_progress.send(field).present? }
  end

  def already_processed?
    %i[banking_approval_completed_at payment_confirmation_completed_at rejection_completed_at].any? do |field|
      @application_progress.send(field).present?
    end
  end
end
