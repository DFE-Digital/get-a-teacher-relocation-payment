require "rails_helper"

RSpec.describe EntryDateStep, type: :model do
  subject(:step) { described_class.new(form) }

  context "teacher" do
    let(:form) { build(:teacher_form) }

    include_examples "behaves like a step",
                     described_class,
                     route_key: "entry-date",
                     required_fields: %i[date_of_entry],
                     question: "Enter the date you moved to England to start your teaching job",
                     question_type: :date
  end

  context "trainee" do
    let(:form) { build(:trainee_form) }

    include_examples "behaves like a step",
                     described_class,
                     route_key: "entry-date",
                     required_fields: %i[date_of_entry],
                     question: "Enter the date you moved to England to start your teacher training course",
                     question_type: :date
  end
end
