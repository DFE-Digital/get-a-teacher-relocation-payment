class StatusBreakdownQuery
  def self.call(scope = ApplicationProgress.all)
    new(scope).execute
  end

  def initialize(scope)
    @scope = scope
  end

  def execute
    ordered_with_defaults(status_breakdown)
  end

private

  def status_breakdown
    @scope.group(:status).count
  end

  def ordered_with_defaults(breakdown)
    ApplicationProgress.statuses.each_with_object({}) do |(key, _), hsh|
      hsh[key] = breakdown.fetch(key, 0)
      hsh
    end
  end
end
