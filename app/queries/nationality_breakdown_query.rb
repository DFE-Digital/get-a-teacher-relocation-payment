class NationalityBreakdownQuery
  def initialize(applications = Application.all)
    @relation = Applicant.all.joins(:application).merge(applications)
  end

  def call
    @relation.group(:nationality).order("count_id DESC, nationality ASC").count(:id)
  end
end
