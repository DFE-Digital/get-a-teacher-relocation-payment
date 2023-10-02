# == Schema Information
#
# Table name: events
#
#  id           :bigint           not null, primary key
#  action       :string
#  data         :jsonb
#  entity_class :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  entity_id    :integer
#
require "rails_helper"

RSpec.describe Event do
  subject(:event) do
    described_class.new(
      action: action,
      entity_class: form.class,
      entity_id: form.id,
      data: data,
    )
  end

  let(:form) { create(:form, given_name: "Ruth") }
  let(:action) { :created }
  let(:data) { form.saved_changes }

  describe "publish" do
    subject(:published_event) { described_class.publish(action, form, data) }

    it { expect(published_event).to be_instance_of(described_class) }

    context "when filtered attributes defined for model event data show '[FILTERED]'" do
      let(:expected_config) do
        {
          "Form" => %w[
            address_line_1
            address_line_2
            city
            postcode
            date_of_birth
            family_name
            given_name
            middle_name
            sex
            nationality
            passport_number
            phone_number
            email_address
          ],
        }
      end
      let(:event_config) { Rails.configuration.x.events.filtered_attributes }
      let(:event_form_given_name) { published_event.data.fetch("given_name") }

      it { expect(event_config).to eq(expected_config) }
      it { expect(event_form_given_name).to contain_exactly(nil, "[FILTERED]") }
    end
  end

  describe "validations" do
    context "presence" do
      it { expect(event).to validate_presence_of(:action) }
      it { expect(event).to validate_presence_of(:entity_class) }
      it { expect(event).to validate_presence_of(:entity_id) }
      it { expect(event).to validate_presence_of(:data) }
    end

    context "when deleted action presence not required" do
      let(:action) { :deleted }

      it { expect(event).not_to validate_presence_of(:data) }
    end

    context "inclusion" do
      it { expect(event).to validate_inclusion_of(:action).in_array(described_class::ACTIONS) }
    end
  end
end
