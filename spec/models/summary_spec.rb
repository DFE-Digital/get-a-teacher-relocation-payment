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
      student_loan: true,
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
        { key: { text: "Application route" },
          value: { text: "I am employed as a teacher in a school in England" },
          actions: [{ href: "/step/application-route", visually_hidden_text: "application route" }] },
        { key: { text: "State funded secondary school" },
          value: { text: "Yes" },
          actions: [{ href: "/step/school-details", visually_hidden_text: "school details" }] },
        { key: { text: "Employed for at least a year" },
          value: { text: "Yes" },
          actions: [{ href: "/step/contract-details", visually_hidden_text: "contract details" }] },
        { key: { text: "Contract start date" },
          value: { text: "01-09-2023" },
          actions: [{ href: "/step/start-date", visually_hidden_text: "start date" }] },
        { key: { text: "Subject" },
          value: { text: "Physics" },
          actions: [{ href: "/step/subject", visually_hidden_text: "subject" }] },
        { key: { text: "Visa type" },
          value: { text: "British National (Overseas) visa" },
          actions: [{ href: "/step/visa", visually_hidden_text: "visa" }] },
        { key: { text: "Date of entry" },
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
        { key: { text: "Email address" }, value: { text: "foo@email.com" } },
        { key: { text: "Family name" }, value: { text: "Smith" } },
        { key: { text: "Middle name" }, value: { text: "Fetnat" } },
        { key: { text: "Given name" }, value: { text: "Marco" } },
        { key: { text: "Telephone" }, value: { text: "07123456789" } },
        { key: { text: "Date of birth" }, value: { text: "24-08-2003" } },
        { key: { text: "Address line 1" }, value: { text: "line 1" } },
        { key: { text: "Address line 2 (optional)" }, value: { text: "line 2" } },
        { key: { text: "Town or city" }, value: { text: "London" } },
        { key: { text: "Postcode" }, value: { text: "EC1 2AA" } },
        { key: { text: "Sex" }, value: { text: "female" } },
        { key: { text: "Nationality" }, value: { text: "Bulgarian" } },
        { key: { text: "Passport number" }, value: { text: "OE75370015I" } },
        { key: { text: "Student loan" }, value: { text: "Yes" } },
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
        { key: { text: "School name" }, value: { text: "School one" } },
        { key: { text: "Headteacher name" }, value: { text: "Miss A. Morice" } },
        { key: { text: "Address line 1" }, value: { text: "line 3" } },
        { key: { text: "Address line 2 (optional)" }, value: { text: "line 4" } },
        { key: { text: "Town or city" }, value: { text: "Nantes" } },
        { key: { text: "Postcode" }, value: { text: "NP3 7AX" } },
      ]
    end

    it { expect(summary.employment_rows).to match_array(expected) }
  end
end
