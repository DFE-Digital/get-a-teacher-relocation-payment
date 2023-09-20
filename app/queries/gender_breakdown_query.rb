class GenderBreakdownQuery
  def initialize(relation = Applicant.all)
    @relation = relation.joins(:application).merge(Application.submitted)
  end

  def call
    @relation.group(:sex).order("count_id DESC").count(:id)
  end
end
