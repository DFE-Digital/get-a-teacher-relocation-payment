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
      "contract must start after the first monday of July of this year"
    in date_of_entry: Date, start_date: Date unless date_of_entry_eligible?(form.date_of_entry, form.start_date)
      "cannot enter the UK more than 3 months before your contract start date"
    else
      nil
    end
  end

  def date_of_entry_eligible?(date_of_entry, start_date)
    date_of_entry >= start_date - 3.months
  end

  def contract_start_date_eligible?(start_date)
    current_year = Date.current.year
    first_monday_in_july = Date.new(current_year, 7, 1)
                             .beginning_of_month
                             .next_occurring(:monday)

    start_date >= first_monday_in_july
  end
end
