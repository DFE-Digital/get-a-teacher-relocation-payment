class RejectionReasonBreakdownQuery
  def initialize(applications = Application.all)
    @relation = ApplicationProgress.all.joins(:application).merge(applications).where.not(rejection_reason: nil)
  end

  def call
    @relation.group(:rejection_reason).order("count_id DESC").count(:id)
  end
end
