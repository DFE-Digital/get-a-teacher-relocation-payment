class SlaBreachedQuery
  def initialize(relation = Application.all)
    @relation = relation.extending(Scopes)
  end

  def call
    @relation.sla_breached
  end

  module Scopes
    def sla_breached
      # Expired SAL rules:
      # Initial Checks ( 2 days )
      # HO Checks ( 3 days )
      # School Checks ( 5 days )
      # Bank Details ( 15 days )
      joins(:application_progress)
      .where(sla_breached_query, 2.days.ago, 3.days.ago, 5.days.ago, 15.days.ago)
    end

  private

    def sla_breached_query
      <<-SQL.squish
        (application_progresses.rejection_completed_at IS NULL) AND
        (
          (applications.created_at IS NOT NULL AND application_progresses.initial_checks_completed_at IS NULL AND applications.created_at < ?) OR
          (application_progresses.initial_checks_completed_at IS NOT NULL AND application_progresses.home_office_checks_completed_at IS NULL AND application_progresses.initial_checks_completed_at < ?) OR
          (application_progresses.home_office_checks_completed_at IS NOT NULL AND application_progresses.school_checks_completed_at IS NULL AND application_progresses.home_office_checks_completed_at < ?) OR
          (application_progresses.school_checks_completed_at IS NOT NULL AND application_progresses.banking_approval_completed_at IS NULL AND application_progresses.school_checks_completed_at < ?)
        )
      SQL
    end
  end
end
