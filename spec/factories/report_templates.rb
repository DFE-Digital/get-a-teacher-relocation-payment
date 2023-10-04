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
      report_class { "Reports::HomeOffice" }
      config do
        {
          "worksheet_name" => "Data",
          "header_mappings" => {
            "Column A" => %w[urn],
            "bar" => %w[applicants.given_name applicants.family_name],
          },
        }
      end
    end
  end
end
