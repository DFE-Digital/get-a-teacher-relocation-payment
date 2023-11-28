class Report
  REGISTERED_REPORTS = {
    home_office: Reports::HomeOfficeCsv,
    home_office_excel: Reports::HomeOfficeExcel,
    standing_data: Reports::StandingData,
    payroll: Reports::Payroll,
    applications: Reports::Applications,
    qa: Reports::QaReport,
  }.freeze

  def self.call(...)
    report = new(...)
    report.data
    report.post_generation_hook
    report.create_audit
    report
  end

  def self.reset(...)
    report = new(...)
    report.reset
    report.create_audit
    report
  end

  def initialize(report_id, **kwargs)
    @kwargs = kwargs&.symbolize_keys || {}
    if Flipper.enabled?(:home_office_excel) && report_id.to_sym == :home_office
      report_id = :home_office_excel
    end
    @report_class = REGISTERED_REPORTS.with_indifferent_access.fetch(report_id)
  rescue KeyError
    raise(ArgumentError, "Invalid report id #{report_id}")
  end

  delegate :name, to: :report
  delegate :filename, to: :report
  delegate :post_generation_hook, to: :report
  delegate :reset, to: :report

  def data
    @data ||= report.generate
  end

  def create_audit
    return reset_audit_trail if report.timestamp

    Audited::Audit.create(
      action: "Downloaded #{name} report",
      user: user,
      comment: {
        resettable: true,
        id: @kwargs.fetch(:id),
        status: @kwargs.fetch(:status, nil),
      }.to_json,
    )
  end

private

  attr_reader :report_class, :kwargs

  def reset_audit_trail
    audit = Audited::Audit.find_by(id: audit_id)
    comment = JSON.parse(audit.comment)
    comment["resettable"] = false
    audit.update(comment: comment.to_json)
    Audited::Audit.create(action: "Reset #{name} report", user: user)
  end

  def report
    @report ||= report_class.new(**kwargs)
  end

  def audit_id
    @kwargs.fetch(:arid)
  end

  def user
    @kwargs.fetch(:user)
  end
end
