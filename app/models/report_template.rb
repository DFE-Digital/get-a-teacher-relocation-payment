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
class ReportTemplate < ApplicationRecord
  validates(:file, presence: true)
  validates(:filename, presence: true)
  validates(:report_class, presence: true, uniqueness: true)
  validates(:config, presence: true)

  validate do |record|
    HomeOfficeReportConfigValidator.new(record).validate
  end
end
