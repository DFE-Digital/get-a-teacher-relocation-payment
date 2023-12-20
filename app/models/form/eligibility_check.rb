#
# Encapsulates business rules around eligibility
#

class Form::EligibilityCheck
  def initialize(form)
    @form = form
  end
  attr_reader :form

  def passed?
    !failed?
  end

  def failed?
    return true if failure_reason

    false
  end

  def failure_reason
    case form
    in application_route: "other"
      "application route other not accecpted"
    in one_year: false, application_route: "teacher"
      "teacher contract duration of less than one year not accepted"
    in state_funded_secondary_school: false
      "school not state funded"
    in subject: "other"
      "taught subject not accepted"
    in visa_type: "Other"
      "visa not accepted"
    in start_date: Date unless contract_start_date_eligible?(form.start_date)
      I18n.t("contract_must_start_within_months", count: months_limit_in_words)
    in date_of_entry: Date, start_date: Date unless date_of_entry_eligible?(form.date_of_entry, form.start_date)
      "cannot enter the UK more than 3 months before your contract start date"
    else
      nil
    end
  end

  def date_of_entry_eligible?(date_of_entry, start_date)
    return false unless date_of_entry && start_date

    date_of_entry >= start_date - 3.months
  end

  def contract_start_date_eligible?(start_date)
    months_before_service_start = AppSettings.current.service_start_date.months_ago(months_limit).beginning_of_month
    start_date >= months_before_service_start
  end

private

  # default to 6 and only allow 5 or 6. anything else results in 6.
  def months_limit
    limit = ENV.fetch("CONTRACT_START_MONTHS_LIMIT", 6).to_i
    [5, 6].include?(limit) ? limit : 6
  end

  def months_limit_in_words
    case months_limit
    when 5
      "five"
    else
      "six"
    end
  end
end
