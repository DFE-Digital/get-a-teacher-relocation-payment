class StatusBreakdownQuery
  def self.call
    new.execute
  end

  def execute
    ordered_with_defaults(status_breakdown)
  end

private

  def status_breakdown
    ApplicationProgress.group(:status).count
  end

  def ordered_with_defaults(breakdown)
    ApplicationProgress.statuses.each_with_object({}) do |(key, _), hsh|
      hsh[key] = breakdown.fetch(key, 0)
      hsh
    end
  end
end
