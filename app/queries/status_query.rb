class StatusQuery
  def initialize(progress)
    @progress = progress
  end

  def current_status
    return :rejected if rejection_completed?
    return :paid if payment_confirmation_completed?
    return :payment_confirmation if banking_approval_completed?
    return :bank_approval if school_checks_completed?
    return :school_checks if home_office_checks_completed?
    return :home_office_checks if initial_checks_completed?

    :initial_checks
  end

private

  def rejection_completed?
    @progress.rejection_completed_at.present?
  end

  def payment_confirmation_completed?
    @progress.payment_confirmation_completed_at.present?
  end

  def banking_approval_completed?
    @progress.banking_approval_completed_at.present?
  end

  def school_checks_completed?
    @progress.school_checks_completed_at.present?
  end

  def home_office_checks_completed?
    @progress.home_office_checks_completed_at.present?
  end

  def initial_checks_completed?
    @progress.initial_checks_completed_at.present?
  end
end
