class FormsFunnelQuery
  def self.call(...)
    new(...).execute
  end

  def initialize(date_range: 24.hours.ago..Time.current)
    @date_range = date_range
    @entity_class = "Form"
    @base_query = Event
                    .select(:entity_id)
                    .distinct
                    .where(entity_class: entity_class, created_at: date_range)
  end

  attr_reader :date_range, :entity_class, :base_query

  def execute
    data = StepFlow::STEPS.each_with_object({}) do |(route_key, step), hsh|
      hsh[route_key] = query_dispatch(step)
      hsh
    end
    data["submission"] = submission_query

    data
  end

  def application_route_step_query(required_field)
    other_query(required_field)
  end

  def school_details_step_query(required_field)
    boolean_query(required_field)
  end

  def trainee_details_step_query(required_field)
    boolean_query(required_field)
  end

  def contract_details_step_query(required_field)
    boolean_query(required_field)
  end

  def start_date_step_query(required_field)
    grouping = extract_dates(required_field)
                 .group_by do |(_id, start_date)|
      Form::EligibilityCheck.new(Form.new).contract_start_date_eligible?(start_date.to_date)
    end

    count_grouping(grouping)
  end

  def subject_step_query(required_field)
    other_query(required_field)
  end

  def visa_step_query(required_field)
    other_query(required_field)
  end

  def entry_date_step_query(required_field)
    date_of_entries = extract_dates(required_field)
    start_dates = extract_dates("start_date")

    form_dates = date_of_entries.each_with_object([]) do |(id, date_of_entry), list|
      entry = start_dates.detect { |(sid, _)| sid == id }
      list << [date_of_entry.to_date, entry&.last&.to_date]
      list
    end

    grouping = form_dates.group_by do |(date_of_entry, start_date)|
      Form::EligibilityCheck.new(Form.new).date_of_entry_eligible?(date_of_entry, start_date)
    end

    count_grouping(grouping)
  end

  def personal_details_step_query(required_field)
    submitted_field_query(required_field)
  end

  def employment_details_step_query(required_field)
    submitted_field_query(required_field)
  end

  def submission_query
    { eligible: base_query.where(action: :deleted).count }
  end

private

  def count_grouping(grouping)
    { eligible: grouping.fetch(true, []).count, ineligible: grouping.fetch(false, []).count }
  end

  def extract_dates(field)
    base_query
      .where("data->'#{field}' IS NOT NULL")
      .pluck(:entity_id, Arel.sql("data->'#{field}'->1"))
  end

  def submitted_field_query(field)
    eligible = base_query.where("data->'#{field}' IS NOT NULL").count

    { eligible: }
  end

  def boolean_query(field)
    ineligible = base_query.where("data->'#{field}' @> ?", "[false]").count
    eligible = base_query.where("data->'#{field}' @> ?", "[true]").count

    { eligible:, ineligible: }
  end

  def other_query(field)
    total = base_query.where("data->'#{field}' IS NOT NULL").count
    ineligible = base_query.where("data->'#{field}' @> ?", '["other"]')
                 .or(base_query.where("data->'#{field}' @> ?", '["Other"]'))
                 .count
    eligible = total - ineligible

    { eligible:, ineligible: }
  end

  def query_dispatch(step)
    method_name = "#{step.name.underscore}_query".to_sym
    required_field = step::REQUIRED_FIELDS.first
    return public_send(method_name, required_field) if respond_to?(method_name)

    raise(NoMethodError, "You must define query method #{method_name}")
  end
end
