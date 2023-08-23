require "rails_helper"

RSpec.describe SubjectStep, type: :model do
  subject(:step) { described_class.new(form) }

  let(:form) { build(:form) }

  context "teacher" do
    let(:form) { build(:teacher_form) }

    question_hint = "Physics, general or combined science including physics, and languages can be combined with other subjects but must make up at least 50% of your time in the classroom. This will be validated by the Department for Education with your school."

    include_examples "behaves like a step",
                     described_class,
                     route_key: "subject",
                     required_fields: %i[subject],
                     question: "What subject are you employed to teach at your school?",
                     question_hint: question_hint,
                     question_type: :radio,
                     valid_answers: [
                       "Physics",
                       "General or combined science, including physics",
                       "Languages",
                       "Other",
                     ]
  end

  context "salaried_trainee" do
    let(:form) { build(:trainee_form) }

    question_hint = "Physics or languages can be combined with other subjects but must make up at least 50% of your course content. This will be validated by Department for Education with the school where you are training."

    include_examples "behaves like a step",
                     described_class,
                     route_key: "subject",
                     required_fields: %i[subject],
                     question: "What subject are you training to teach?",
                     question_hint: question_hint,
                     question_type: :radio,
                     valid_answers: %w[
                       Physics
                       Languages
                       Other
                     ]
  end
end
