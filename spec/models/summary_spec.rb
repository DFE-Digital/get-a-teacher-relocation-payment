# frozen_string_literal: true

require "rails_helper"

RSpec.describe Summary do
  subject(:summary) { described_class.new(application:) }

  let(:application) { build(:teacher_application, :submitted) }
  let(:translated) { "text" }
  let(:model_attributes) do
    {
      "field_1" => "value_1",
      "field_2" => "value_2",
    }
  end

  describe "#rows" do
    it "returns an array of rows" do
      expect(summary.rows).to be_an(Array)
    end

    it "includes application_route row" do
      expect(summary.rows).to include(summary.application_route)
    end

    it "includes school_details row" do
      expect(summary.rows).to include(summary.school_details)
    end

    it "includes contract_details row" do
      expect(summary.rows).to include(summary.contract_details)
    end

    it "includes contract_start_dates row" do
      expect(summary.rows).to include(summary.contract_start_dates)
    end

    it "includes subjects row" do
      expect(summary.rows).to include(summary.subjects)
    end

    it "includes visa row" do
      expect(summary.rows).to include(summary.visa)
    end

    it "includes entry_date row" do
      expect(summary.rows).to include(summary.entry_date)
    end
  end

  describe "#personal_card" do
    it "returns the title translated using i18n" do
      expect(summary).to receive(:t).with("applicants.personal_details.title").and_return(translated)
      expect(summary.personal_card[:title]).to eq(translated)
    end
  end

  describe "#personal_rows" do
    before do
      allow(summary).to receive(:displayed_personal_fields).and_return(model_attributes)
    end

    it "returns an array of hashes with key and value keys" do
      expect(summary.personal_rows).to all(include(:key, :value))
    end

    it "translates the key using i18n" do
      expect(summary).to receive(:t).with("applicants.personal_details.field_1").and_return(translated)
      expect(summary).to receive(:t).with("applicants.personal_details.field_2").and_return(translated)
      expect(summary.personal_rows).to include(include(key: { text: translated }))
    end

    it "returns the corresponding value in the value key" do
      expect(summary.personal_rows).to include(include(value: { text: "value_1" }))
      expect(summary.personal_rows).to include(include(value: { text: "value_2" }))
    end
  end

  describe "#employment_card" do
    it "returns the title translated using i18n" do
      expect(summary).to receive(:t).with("applicants.employment_details.title").and_return(translated)
      expect(summary.employment_card[:title]).to eq(translated)
    end
  end

  describe "#employment_rows" do
    before do
      allow(summary).to receive(:displayed_employment_fields).and_return(model_attributes)
    end

    it "returns an array of hashes with key and value keys" do
      expect(summary.employment_rows).to all(include(:key, :value))
    end

    it "translates the key using i18n" do
      expect(summary).to receive(:t).with("applicants.employment_details.field_1").and_return(translated)
      expect(summary).to receive(:t).with("applicants.employment_details.field_2").and_return(translated)
      expect(summary.employment_rows).to include(include(key: { text: translated }))
    end

    it "returns the corresponding value in the value key" do
      expect(summary.employment_rows).to include(include(value: { text: "value_1" }))
      expect(summary.employment_rows).to include(include(value: { text: "value_2" }))
    end
  end

  describe "#application_route" do
    let(:test_method) { summary.application_route }

    it "returns summary rows for application_route" do
      expect(summary).to receive(:t).with("applicants.application_routes.title").and_return("key")
      expect(summary).to receive(:t).with("applicants.application_routes.radio_button.teacher.text").and_return("value")

      expect(test_method[:key]).to eq({ text: "key" })
      expect(test_method[:value]).to eq({ text: "value" })
    end
  end

  describe "#school_details" do
    let(:test_method) { summary.school_details }

    it "returns summary rows for school_details" do
      expect(summary).to receive(:t).with("applicants.school_details.title").and_return("key")

      expect(test_method[:key]).to eq({ text: "key" })
      expect(test_method[:value]).to eq({ text: "Yes" })
    end
  end

  describe "#contract_details" do
    let(:test_method) { summary.contract_details }

    it "returns summary rows for contract_details" do
      expect(summary).to receive(:t).with("applicants.contract_details.title").and_return("key")

      expect(test_method[:key]).to eq({ text: "key" })
      expect(test_method[:value]).to eq({ text: "Yes" })
    end
  end

  describe "#contract_start_dates" do
    let(:test_method) { summary.contract_start_dates }

    it "returns summary rows for contract_start_dates" do
      expect(summary).to receive(:t).with("applicants.contract_start_dates.title").and_return("key")

      expect(test_method[:key]).to eq({ text: "key" })
      expect(test_method[:value]).to eq({ text: application.start_date })
    end
  end

  describe "#subjects" do
    let(:test_method) { summary.subjects }

    it "returns summary rows for subjects" do
      expect(summary).to receive(:t).with("applicants.subjects.title.teacher").and_return("key")

      expect(test_method[:key]).to eq({ text: "key" })
      expect(test_method[:value]).to eq({ text: application.subject })
    end
  end

  describe "#visa" do
    let(:test_method) { summary.visa }

    it "returns summary rows for visa" do
      expect(summary).to receive(:t).with("applicants.visa.title").and_return("key")

      expect(test_method[:key]).to eq({ text: "key" })
      expect(test_method[:value]).to eq({ text: application.visa_type })
    end
  end

  describe "#entry_date" do
    let(:test_method) { summary.entry_date }

    it "returns summary rows for entry_date" do
      expect(summary).to receive(:t).with("applicants.entry_dates.title.teacher").and_return("key")

      expect(test_method[:key]).to eq({ text: "key" })
      expect(test_method[:value]).to eq({ text: application.date_of_entry })
    end
  end
end
