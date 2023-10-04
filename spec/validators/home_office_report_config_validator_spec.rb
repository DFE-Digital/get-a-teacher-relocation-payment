require "rails_helper"

describe HomeOfficeReportConfigValidator do
  subject(:validator) { described_class.new(report_template) }

  let(:report_template) { build(:home_office_report_template, config:) }

  before { validator.validate }

  context "when not a home office report_template skip validation" do
    let(:report_template) { build(:report_template) }

    it { expect(report_template.errors[:file]).to be_blank }
    it { expect(report_template.errors[:config]).to be_blank }
  end

  context "returns error on file" do
    let(:report_template) { build(:home_office_report_template, file: "bad_file") }

    it { expect(report_template.errors[:file]).not_to be_blank }
  end

  context "returns error on config" do
    context "when missing worksheet_name" do
      let(:config) do
        {
          "header_mappings" => {
            "Column A" => %w[urn],
          },
        }
      end

      it { expect(report_template.errors[:config]).not_to be_blank }
    end

    context "when worksheet_name does not exist is file" do
      let(:config) do
        {
          "worksheet_name" => "unknown",
          "header_mappings" => {
            "Column A" => %w[urn],
          },
        }
      end

      it { expect(report_template.errors[:config]).not_to be_blank }
    end

    context "when missing header_mappgins" do
      let(:config) do
        {
          "worksheet_name" => "Data",
        }
      end

      it { expect(report_template.errors[:config]).not_to be_blank }
    end

    context "when header_mappgins blank" do
      let(:config) do
        {
          "worksheet_name" => "Data",
          "header_mappings" => {},
        }
      end

      it { expect(report_template.errors[:config]).not_to be_blank }
    end
  end
end
