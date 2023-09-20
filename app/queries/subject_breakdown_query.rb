class SubjectBreakdownQuery
  def initialize(relation = Application.all)
    @relation = relation.submitted
  end

  def call
    @relation.group(:subject).order("count_id DESC").count(:id)
  end
end
