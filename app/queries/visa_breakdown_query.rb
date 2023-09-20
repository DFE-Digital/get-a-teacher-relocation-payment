class VisaBreakdownQuery
  def initialize(relation = Application.all)
    @relation = relation.submitted
  end

  def call
    Rails.logger.debug(Application.count)
    @relation.group(:visa_type).order("count_id DESC").count(:id)
  end
end
