# frozen_string_literal: true

class Summary
  include ActiveModel::Model
  include ActionView::Helpers::TranslationHelper
  include Rails.application.routes.url_helpers

  def url_options
    { only_path: true }
  end

  def initialize(application:)
    @application = application
  end

  def rows
    [
      application_route,
      school_details,
      contract_details,
      contract_start_dates,
      subjects,
      visa,
      entry_date,
    ]
  end

  def personal_card
    link = yield("Change", new_applicants_personal_detail_path)
    {
      title: t("applicants.personal_details.title"),
      actions: [link],
    }
  end

  def personal_rows
    displayed_personal_fields
      .map do |field, value|
      {
        key: { text: t("applicants.personal_details.#{field}") },
        value: { text: value },
      }
    end
  end

  def employment_card
    link = yield("Change", new_applicants_employment_detail_path)
    {
      title: t("applicants.employment_details.title"),
      actions: [link],
    }
  end

  def employment_rows
    displayed_employment_fields
      .map do |field, value|
      {
        key: { text: t("applicants.employment_details.#{field}") },
        value: { text: value },
      }
    end
  end

  def application_route
    {
      key: { text: t("applicants.application_routes.title") },
      value: { text: t("applicants.application_routes.radio_button.#{application.application_route}.text") },
      actions: [
        {
          href: new_applicants_application_route_path(application_route: application.application_route),
          visually_hidden_text: "application_route",
        },
      ],
    }
  end

  def school_details
    {
      key: { text: t("applicants.school_details.title") },
      value: { text: "Yes" },
      actions: [
        {
          href: new_applicants_school_detail_path(state_funded_secondary_school: "yes"),
          visually_hidden_text: "school details",
        },
      ],
    }
  end

  def contract_details
    {
      key: { text: t("applicants.contract_details.title") },
      value: { text: "Yes" },
      actions: [
        {
          href: new_applicants_contract_detail_path(one_year: "yes"),
          visually_hidden_text: "contract details",
        },
      ],
    }
  end

  def contract_start_dates
    {
      key: { text: t("applicants.contract_start_dates.title") },
      value: { text: application.start_date },
      actions: [
        {
          href: new_applicants_contract_start_date_path,
          visually_hidden_text: "contract start dates",
        },
      ],
    }
  end

  def subjects
    {
      key: { text: t("applicants.subjects.title.#{application.application_route}") },
      value: { text: application.subject },
      actions: [
        {
          href: new_applicants_subject_path,
          visually_hidden_text: "subjects",
        },
      ],
    }
  end

  def visa
    {
      key: { text: t("applicants.visa.title") },
      value: { text: application.visa_type },
      actions: [
        {
          href: new_applicants_visa_path,
          visually_hidden_text: "visa",
        },
      ],
    }
  end

  def entry_date
    {
      key: { text: t("applicants.entry_dates.title.#{application.application_route}") },
      value: { text: application.date_of_entry },
      actions: [
        {
          href: new_applicants_entry_date_path,
          visually_hidden_text: "entry date",
        },
      ],
    }
  end

private

  attr_reader :application

  def displayed_personal_fields
    applicant_attributes.merge(address_attributes(application.applicant&.address))
  end

  def displayed_employment_fields
    applicant_school_attributes.merge(address_attributes(application.applicant&.school&.address))
  end

  def display_fields(model, fields)
    return {} unless model

    model
      .attributes
      .select { |k, _| fields.include?(k) }
  end

  def applicant_attributes
    fields = %w[
      given_name
      family_name
      email_address
      phone_number
      date_of_birth
      nationality
      sex
      passport_number
    ]
    attrs = display_fields(application.applicant, fields)
    attrs["phone_number.title"] = attrs["phone_number"]
    attrs.delete("phone_number")
    attrs
  end

  def address_attributes(address)
    fields = %(
      address_line_1
      address_line_2
      city
      postcode
      )
    display_fields(address, fields)
  end

  def applicant_school_attributes
    school = application.applicant&.school
    display_fields(school, %w[headteacher_name name])
  end
end
