class Report
  REGISTERED_REPORTS = {
    home_office: Reports::HomeOffice,
    standing_data: Reports::StandingData,
    payroll: Reports::Payroll,
    applications: Reports::Applications,
    qa: Reports::QaReport,
  }.freeze

  def self.call(...)
    report = new(...)
    report.data
    report.post_generation_hook
    report
  end

  def initialize(report_id, **kwargs)
    @kwargs = kwargs&.symbolize_keys || {}
    @report_class = REGISTERED_REPORTS.with_indifferent_access.fetch(report_id)
  rescue KeyError
    raise(ArgumentError, "Invalid report id #{report_id}")
  end

  delegate :name, to: :report
  delegate :filename, to: :report
  delegate :post_generation_hook, to: :report

  def data
    @data ||= report.csv
  end

private

  attr_reader :report_class, :kwargs

  def report
    @report ||= report_class.new(**kwargs)
  end
end
