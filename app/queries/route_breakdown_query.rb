class RouteBreakdownQuery
  def initialize(relation = Application.all)
    @relation = relation.submitted
  end

  def call
    @relation.group(:application_route).order("count_id DESC").count(:id)
  end
end
