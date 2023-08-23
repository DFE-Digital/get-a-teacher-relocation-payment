# frozen_string_literal: true

require "rails_helper"

RSpec.describe Summary do
  subject(:summary) { described_class.new(form) }

  let(:form) do
    build(
      :form,
      application_route: "teacher",
      state_funded_secondary_school: true,
      one_year: true,
      visa_type: "British National (Overseas) visa",
      start_date: Date.new(Date.current.year, 9, 1),
      date_of_entry: Date.new(Date.current.year, 9, 1),
      subject: "physics",
      date_of_birth: Date.new(2003, 8, 24),
      email_address: "foo@email.com",
      family_name: "Smith",
      given_name: "Marco",
      middle_name: "Fetnat",
      phone_number: "07123456789",
      sex: "female",
      address_line_1: "line 1",
      address_line_2: "line 2",
      city: "London",
      postcode: "EC1 2AA",
      passport_number: "OE75370015I",
      nationality: NATIONALITIES[31],
      school_headteacher_name: "Miss A. Morice",
      school_name: "School one",
      school_address_line_1: "line 3",
      school_address_line_2: "line 4",
      school_city: "Nantes",
      school_postcode: "NP3 7AX",
    )
  end

  describe "rows" do
    let(:expected_rows) do
      [
        { key: { text: "What is your employment status?" },
          value: { text: "I am employed as a teacher in a school in England" },
          actions: [{ href: "/step/application-route", visually_hidden_text: "application route" }] },
        { key: { text: "Are you employed by an English state secondary school?" },
          value: { text: "Yes" },
          actions: [{ href: "/step/school-details", visually_hidden_text: "school details" }] },
        { key: { text: "Are you employed on a contract lasting at least one year?" },
          value: { text: "Yes" },
          actions: [{ href: "/step/contract-details", visually_hidden_text: "contract details" }] },
        { key: { text: "Enter the start date of your contract" },
          value: { text: "01-09-2023" },
          actions: [{ href: "/step/start-date", visually_hidden_text: "start date" }] },
        { key: { text: "What subject are you employed to teach at your school?" },
          value: { text: "Physics" },
          actions: [{ href: "/step/subject", visually_hidden_text: "subject" }] },
        { key: { text: "Select the visa you used to move to England" },
          value: { text: "British National (Overseas) visa" },
          actions: [{ href: "/step/visa", visually_hidden_text: "visa" }] },
        { key: { text: "Enter the date you moved to England to start your teaching job" },
          value: { text: "01-09-2023" },
          actions: [{ href: "/step/entry-date", visually_hidden_text: "entry date" }] },
      ]
    end

    it { expect(summary.rows).to match_array(expected_rows) }
  end

  describe "personal_card" do
    let(:expected) do
      {
        title: "Personal information",
        actions: ["Change - /step/personal-details"],
      }
    end
    let(:output) { summary.personal_card { |a, b| "#{a} - #{b}" } }

    it { expect(output).to eq(expected) }
  end

  describe "personal_rows" do
    let(:expected) do
      [
        { key: { text: "Enter your current email address" }, value: { text: "foo@email.com" } },
        { key: { text: "Enter your family name, as it appears on your passport" }, value: { text: "Smith" } },
        { key: { text: "Enter your middle name, as it appears on your passport" }, value: { text: "Fetnat" } },
        { key: { text: "Enter your given name, as it appears on your passport" }, value: { text: "Marco" } },
        { key: { text: "Enter your current phone number" }, value: { text: "07123456789" } },
        { key: { text: "Enter your date of birth, as it appears on your passport" },
          value: { text: "24-08-2003" } },
        { key: { text: "Address line 1" }, value: { text: "line 1" } },
        { key: { text: "Address line 2 (optional)" }, value: { text: "line 2" } },
        { key: { text: "Town or city" }, value: { text: "London" } },
        { key: { text: "Postcode" }, value: { text: "EC1 2AA" } },
        { key: { text: "Select your sex" }, value: { text: "female" } },
        { key: { text: "Select your nationality" }, value: { text: "Bulgarian" } },
        { key: { text: "Enter your passport number, as it appears on your passport" }, value: { text: "OE75370015I" } },
      ]
    end

    it { expect(summary.personal_rows).to match_array(expected) }
  end

  describe "employment_card" do
    let(:expected) do
      {
        title: "Employment information",
        actions: ["Change - /step/employment-details"],
      }
    end
    let(:output) { summary.employment_card { |a, b| "#{a} - #{b}" } }

    it { expect(output).to eq(expected) }
  end

  describe "employment_rows" do
    let(:expected) do
      [
        { key: { text: "Enter the name of the school" }, value: { text: "School one" } },
        { key: { text: "Enter the name of the headteacher of the school where you are employed as a teacher" },
          value: { text: "Miss A. Morice" } },
        { key: { text: "Address line 1" }, value: { text: "line 3" } },
        { key: { text: "Address line 2 (optional)" }, value: { text: "line 4" } },
        { key: { text: "Town or city" }, value: { text: "Nantes" } },
        { key: { text: "Postcode" }, value: { text: "NP3 7AX" } },
      ]
    end

    it { expect(summary.employment_rows).to match_array(expected) }
  end
end
