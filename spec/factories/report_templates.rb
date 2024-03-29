# == Schema Information
#
# Table name: report_templates
#
#  id           :bigint           not null, primary key
#  config       :jsonb
#  file         :binary
#  filename     :string
#  report_class :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :report_template do
    file { StringIO.new("") }
    filename { "file.xlsx" }
    report_class { "SomeClass" }
    config do
      {
        "some" => true,
      }
    end

    factory :home_office_report_template do
      file { Rails.root.join("spec/fixtures/test_homeoffice_template.xlsx").read }
      filename { "test_homeoffice_template.xlsx" }
      report_class { "Reports::HomeOfficeExcel" }
      config do
        {
          "worksheet_name" => "TestData",
          "header_mappings" => {
            "Column A" => %w[urn],
            "bar" => %w[applicants.given_name applicants.family_name],
          },
        }
      end
    end

    factory :mocked_home_office_report_template do
      file { Rails.root.join("spec/fixtures/test_homeoffice_template.xlsx").read }
      filename { "test_homeoffice_template.xlsx" }
      report_class { "Reports::HomeOfficeExcel" }
      config do
        {
          "worksheet_name" => "Data",
          "header_mappings" => {
            "ID (Mandatory)" => %w[urn],
            "Full Name/ Organisation Name" => %w[applicants.given_name applicants.middle_name applicants.family_name],
            "DOB" => %w[applicants.date_of_birth],
            "Nationality" => %w[applicants.nationality],
            "Passport Number" => %w[applicants.passport_number],
          },
        }
      end
    end
  end
end
