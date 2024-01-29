class TimeToBankingApprovalQuery
  include InflectionHelper
  def initialize(relation = ApplicationProgress.all)
    @relation = relation
  end

  def call
    applications_list = @relation.where.not(school_checks_completed_at: nil).where.not(banking_approval_completed_at: nil)
    durations = applications_list.map { |app| (app.banking_approval_completed_at.to_date - app.school_checks_completed_at.to_date).to_i }
    calculate_day_stats(durations)
  end
end
