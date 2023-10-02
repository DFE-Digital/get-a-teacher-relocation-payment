require "rails_helper"

RSpec.describe FormsFunnelQuery, type: :service do
  subject(:forms_funnel) { described_class.new(date_range:) }

  let(:date_range) { 1.day.ago..Time.current }

  describe ".submission_query" do
    before do
      create_list(:form_submitted_event, 2)
    end

    let(:expected) { { eligible: 2 } }

    it { expect(forms_funnel.submission_query).to eq(expected) }
  end

  describe ".employment_details_step_query" do
    before do
      create_list(:form_employment_details_event, 3)
    end

    let(:expected) { { eligible: 3 } }

    it { expect(forms_funnel.employment_details_step_query("school_name")).to eq(expected) }
  end

  describe ".personal_details_step_query" do
    before do
      create_list(:form_personal_details_event, 4)
    end

    let(:expected) { { eligible: 4 } }

    it { expect(forms_funnel.personal_details_step_query("given_name")).to eq(expected) }
  end

  describe ".entry_date_step_query" do
    before do
      old_start_date = create(:form_start_date_four_months_ago_event)
      create(:ineligible_form_date_of_entry_event, entity_id: old_start_date.entity_id)
      start_dates = create_list(:form_start_date_event, 6)
      build_list(:form_date_of_entry_event, 5) do |event, i|
        event.entity_id = start_dates[i].entity_id
        event.save
      end
    end

    let(:expected) { { eligible: 5, ineligible: 1 } }

    it { expect(forms_funnel.entry_date_step_query("date_of_entry")).to eq(expected) }
  end

  describe ".start_date_step_query" do
    before do
      create_list(:form_start_date_event, 6)
      create(:ineligible_form_start_date_event)
    end

    let(:expected) { { eligible: 6, ineligible: 1 } }

    it { expect(forms_funnel.start_date_step_query("start_date")).to eq(expected) }
  end

  describe ".application_route_step_query" do
    before do
      create_list(:form_application_route_event, 6)
      create(:ineligible_form_application_route_event)
    end

    let(:expected) { { eligible: 6, ineligible: 1 } }

    it { expect(forms_funnel.application_route_step_query("application_route")).to eq(expected) }
  end

  describe ".school_details_step_query" do
    before do
      create_list(:form_school_details_event, 3)
      create(:ineligible_form_school_details_event)
    end

    let(:expected) { { eligible: 3, ineligible: 1 } }

    it { expect(forms_funnel.school_details_step_query("state_funded_secondary_school")).to eq(expected) }
  end
end
