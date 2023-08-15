# frozen_string_literal: true

require "rails_helper"

RSpec.describe Summary do
  subject { described_class.new(application:) }

  let(:application) { build(:teacher_application, :submitted) }
  let(:translated) { "text" }
  let(:model_attributes) do
    {
      "field_1" => "value_1",
      "field_2" => "value_2",
    }
  end

  describe "#url_options" do
    it "returns only_path as true" do
      expect(subject.url_options).to eq({ only_path: true })
    end
  end

  describe "#rows" do
    it "returns an array of rows" do
      expect(subject.rows).to be_an(Array)
    end

    it "includes application_route row" do
      expect(subject.rows).to include(subject.application_route)
    end

    it "includes school_details row" do
      expect(subject.rows).to include(subject.school_details)
    end

    it "includes contract_details row" do
      expect(subject.rows).to include(subject.contract_details)
    end

    it "includes contract_start_dates row" do
      expect(subject.rows).to include(subject.contract_start_dates)
    end

    it "includes subjects row" do
      expect(subject.rows).to include(subject.subjects)
    end

    it "includes visa row" do
      expect(subject.rows).to include(subject.visa)
    end

    it "includes entry_date row" do
      expect(subject.rows).to include(subject.entry_date)
    end
  end

  describe "#personal_card" do
    let(:block) { proc { "<a>link</a>" } }

    it "returns the title translated using i18n" do
      expect(subject).to receive(:t).with("applicants.personal_details.title").and_return(translated)
      expect(subject.personal_card(&block)[:title]).to eq(translated)
    end

    it "returns actions array containing the yielded link" do
      expect(subject.personal_card(&block)[:actions]).to eq(["<a>link</a>"])
    end
  end

  describe "#personal_rows" do
    before do
      allow(subject).to receive(:displayed_personal_fields).and_return(model_attributes)
    end

    it "returns an array of hashes with key and value keys" do
      expect(subject.personal_rows).to all(include(:key, :value))
    end

    it "translates the key using i18n" do
      expect(subject).to receive(:t).with("applicants.personal_details.field_1").and_return(translated)
      expect(subject).to receive(:t).with("applicants.personal_details.field_2").and_return(translated)
      expect(subject.personal_rows).to include(include(key: { text: translated }))
    end

    it "returns the corresponding value in the value key" do
      expect(subject.personal_rows).to include(include(value: { text: "value_1" }))
      expect(subject.personal_rows).to include(include(value: { text: "value_2" }))
    end
  end

  describe "#employment_card" do
    let(:block) { proc { "<a>link</a>" } }

    it "returns the title translated using i18n" do
      expect(subject).to receive(:t).with("applicants.employment_details.title").and_return(translated)
      expect(subject.employment_card(&block)[:title]).to eq(translated)
    end

    it "returns actions array containing the yielded link" do
      expect(subject.employment_card(&block)[:actions]).to eq(["<a>link</a>"])
    end
  end

  describe "#employment_rows" do
    before do
      allow(subject).to receive(:displayed_employment_fields).and_return(model_attributes)
    end

    it "returns an array of hashes with key and value keys" do
      expect(subject.employment_rows).to all(include(:key, :value))
    end

    it "translates the key using i18n" do
      expect(subject).to receive(:t).with("applicants.employment_details.field_1").and_return(translated)
      expect(subject).to receive(:t).with("applicants.employment_details.field_2").and_return(translated)
      expect(subject.employment_rows).to include(include(key: { text: translated }))
    end

    it "returns the corresponding value in the value key" do
      expect(subject.employment_rows).to include(include(value: { text: "value_1" }))
      expect(subject.employment_rows).to include(include(value: { text: "value_2" }))
    end
  end

  describe "#application_route" do
    let(:test_method) { subject.application_route }

    it "returns summary rows for application_route" do
      expect(subject).to receive(:t).with("applicants.application_routes.title").and_return("key")
      expect(subject).to receive(:t).with("applicants.application_routes.radio_button.teacher.text").and_return("value")

      expect(test_method[:key]).to eq({ text: "key" })
      expect(test_method[:value]).to eq({ text: "value" })
      expect(test_method.dig(:actions, 0, :href)).to eq("/applicants/application_routes/new?application_route=teacher")
      expect(test_method.dig(:actions, 0, :visually_hidden_text)).to eq("application_route")
    end
  end

  describe "#school_details" do
    let(:test_method) { subject.school_details }

    it "returns summary rows for school_details" do
      expect(subject).to receive(:t).with("applicants.school_details.title").and_return("key")

      expect(test_method[:key]).to eq({ text: "key" })
      expect(test_method[:value]).to eq({ text: "Yes" })
      expect(test_method.dig(:actions, 0, :href)).to eq("/applicants/school_details/new?state_funded_secondary_school=yes")
      expect(test_method.dig(:actions, 0, :visually_hidden_text)).to eq("school details")
    end
  end

  describe "#contract_details" do
    let(:test_method) { subject.contract_details }

    it "returns summary rows for contract_details" do
      expect(subject).to receive(:t).with("applicants.contract_details.title").and_return("key")

      expect(test_method[:key]).to eq({ text: "key" })
      expect(test_method[:value]).to eq({ text: "Yes" })
      expect(test_method.dig(:actions, 0, :href)).to eq("/applicants/contract_details/new?one_year=yes")
      expect(test_method.dig(:actions, 0, :visually_hidden_text)).to eq("contract details")
    end
  end

  describe "#contract_start_dates" do
    let(:test_method) { subject.contract_start_dates }

    it "returns summary rows for contract_start_dates" do
      expect(subject).to receive(:t).with("applicants.contract_start_dates.title").and_return("key")

      expect(test_method[:key]).to eq({ text: "key" })
      expect(test_method[:value]).to eq({ text: application.start_date })
      expect(test_method.dig(:actions, 0, :href)).to eq("/applicants/contract_start_dates/new")
      expect(test_method.dig(:actions, 0, :visually_hidden_text)).to eq("contract start dates")
    end
  end

  describe "#subjects" do
    let(:test_method) { subject.subjects }

    it "returns summary rows for subjects" do
      expect(subject).to receive(:t).with("applicants.subjects.title.teacher").and_return("key")

      expect(test_method[:key]).to eq({ text: "key" })
      expect(test_method[:value]).to eq({ text: application.subject })
      expect(test_method.dig(:actions, 0, :href)).to eq("/applicants/subjects/new")
      expect(test_method.dig(:actions, 0, :visually_hidden_text)).to eq("subjects")
    end
  end

  describe "#visa" do
    let(:test_method) { subject.visa }

    it "returns summary rows for visa" do
      expect(subject).to receive(:t).with("applicants.visa.title").and_return("key")

      expect(test_method[:key]).to eq({ text: "key" })
      expect(test_method[:value]).to eq({ text: application.visa_type })
      expect(test_method.dig(:actions, 0, :href)).to eq("/applicants/visas/new")
      expect(test_method.dig(:actions, 0, :visually_hidden_text)).to eq("visa")
    end
  end

  describe "#entry_date" do
    let(:test_method) { subject.entry_date }

    it "returns summary rows for entry_date" do
      expect(subject).to receive(:t).with("applicants.entry_dates.title.teacher").and_return("key")

      expect(test_method[:key]).to eq({ text: "key" })
      expect(test_method[:value]).to eq({ text: application.date_of_entry })
      expect(test_method.dig(:actions, 0, :href)).to eq("/applicants/entry_dates/new")
      expect(test_method.dig(:actions, 0, :visually_hidden_text)).to eq("entry date")
    end
  end
end
