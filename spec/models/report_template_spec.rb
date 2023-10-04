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
require "rails_helper"

RSpec.describe ReportTemplate do
  describe "validations" do
    context "common report template validation" do
      subject(:report_template) { build(:report_template) }

      it { expect(report_template).to validate_presence_of(:file) }
      it { expect(report_template).to validate_presence_of(:filename) }
      it { expect(report_template).to validate_presence_of(:report_class) }
      it { expect(report_template).to validate_uniqueness_of(:report_class) }
      it { expect(report_template).to validate_presence_of(:config) }
    end

    context "homeoffice report validation" do
      subject(:report_template) { build(:home_office_report_template) }

      let(:validator) { HomeOfficeReportConfigValidator.new(report_template) }

      before do
        allow(HomeOfficeReportConfigValidator).to receive(:new).and_return(validator)
        report_template.valid?
      end

      it { expect(report_template).to be_valid }

      it { expect(HomeOfficeReportConfigValidator).to have_received(:new).with(report_template) }
    end
  end
end
