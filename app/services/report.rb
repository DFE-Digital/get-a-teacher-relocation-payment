class Report
  REGISTERED_REPORTS = {
    home_office: Reports::HomeOffice,
    standing_data: Reports::StandingData,
    payroll: Reports::Payroll,
    applications: Reports::Applications,
    qa: Reports::QaReport,
  }.freeze

  def self.call(...)
    service = new(...)
    service.data
    service
  end

  def initialize(report_id, **kwargs)
    @kwargs = kwargs&.symbolize_keys || {}
    @report_class = REGISTERED_REPORTS.with_indifferent_access.fetch(report_id)
  rescue KeyError
    raise(ArgumentError, "Invalid report id #{report_id}")
  end

  def report_name
    report_class.to_s.capitalize
  end

  def filename
    report.name
  end

  def data
    report.csv
  end

private

  attr_reader :report_class, :kwargs

  def report
    return @report if @report
    return @report = report_class.new(*report_args) if report_args

    @report = report_class.new
  end

  def report_args
    return qa_report_args if report_class == Reports::QaReport

    nil
  end

  def qa_report_args
    return @qa_report_args if @qa_report_args

    status = kwargs.fetch(:status)
    applications = Application.filter_by_status(status).reject(&:qa?)
    applications.each(&:mark_as_qa!)

    @qa_report_args = [applications, status]
  end
end
