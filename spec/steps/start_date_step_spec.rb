require "rails_helper"

RSpec.describe StartDateStep, type: :model do
  subject(:step) { described_class.new(form) }

  let(:form) { build(:form) }

  include_examples "behaves like a step",
                   described_class,
                   route_key: "start-date",
                   required_fields: %i[start_date],
                   question: "Enter the start date of your contract",
                   question_type: :date
end
