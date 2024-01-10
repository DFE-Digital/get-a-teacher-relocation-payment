class GenderBreakdownQuery
  def initialize(applications = Application.all)
    @relation = Applicant.all.joins(:application).merge(applications)
  end

  def call
    @relation.group(:sex).order("count_id DESC").count(:id)
  end
end
