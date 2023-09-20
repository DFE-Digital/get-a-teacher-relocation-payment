class NationalityBreakdownQuery
  def initialize(relation = Applicant.all)
    @relation = relation.joins(:application).merge(Application.all)
  end

  def call
    @relation.group(:nationality).order("count_id DESC, nationality ASC").count(:id)
  end
end
