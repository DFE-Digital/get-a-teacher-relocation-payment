class RejectionReasonBreakdownQuery
  def initialize(relation = ApplicationProgress.all)
    @relation = relation.joins(:application).merge(Application.all).where.not(rejection_reason: nil)
  end

  def call
    @relation.group(:rejection_reason).order("count_id DESC").count(:id)
  end
end
