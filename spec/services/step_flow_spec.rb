require "rails_helper"

RSpec.describe StepFlow do
  subject(:step_flow) { described_class }

  describe "registered steps" do
    subject(:registered_steps) { described_class::STEPS }

    let(:expected) do
      %w[
        application-route
        contract-details
        employment-details
        entry-date
        personal-details
        school-details
        start-date
        subject
        trainee-details
        visa
      ]
    end

    it { expect(registered_steps.keys).to match_array(expected) }
  end

  describe "teacher_steps" do
    let(:expected) do
      [
        ApplicationRouteStep,
        SchoolDetailsStep,
        ContractDetailsStep,
        StartDateStep,
        SubjectStep,
        VisaStep,
        EntryDateStep,
        PersonalDetailsStep,
        EmploymentDetailsStep,
      ]
    end

    it { expect(step_flow.teacher_steps).to match_array(expected) }
  end

  describe "trainee_steps" do
    let(:expected) do
      [
        ApplicationRouteStep,
        TraineeDetailsStep,
        StartDateStep,
        SubjectStep,
        VisaStep,
        EntryDateStep,
        PersonalDetailsStep,
        EmploymentDetailsStep,
      ]
    end

    it { expect(step_flow.trainee_steps).to match_array(expected) }
  end

  describe "matches?" do
    let(:request) { double(params: { name: step_name }) }

    context "valid registered step key" do
      let(:step_name) { "application-route" }

      it { expect(step_flow.matches?(request)).to be true }
    end

    context "invalid registered step key" do
      let(:step_name) { "admin" }

      it { expect(step_flow.matches?(request)).to be false }
    end
  end

  describe "current_step" do
    subject(:current_step) { described_class.current_step(form, step_name) }

    context "when form is nil" do
      let(:form) { nil }
      let(:step_name) { "personal-details" }

      it { is_expected.to be_nil }
    end

    context "when form is nil and requested step is application-route" do
      let(:form) { nil }
      let(:step_name) { "application-route" }

      it { is_expected.to be_instance_of(ApplicationRouteStep) }
    end

    context "when form is present" do
      let(:form) { build(:form) }
      let(:step_name) { "personal-details" }

      it { is_expected.to be_instance_of(PersonalDetailsStep) }
    end
  end

  describe "next_step_path" do
    context "teacher" do
      let(:form) { build(:teacher_form, :eligible) }

      [
        [ApplicationRouteStep, "/step/school-details"],
        [SchoolDetailsStep, "/step/contract-details"],
        [ContractDetailsStep, "/step/start-date"],
        [StartDateStep, "/step/subject"],
        [SubjectStep, "/step/visa"],
        [VisaStep, "/step/entry-date"],
        [EntryDateStep, "/step/personal-details"],
        [PersonalDetailsStep, "/step/employment-details"],
        [EmploymentDetailsStep, "/summary"],
      ].each do |step_class, expected_path|
        it "#{step_class} -> #{expected_path}" do
          step = step_class.new(form)
          expect(step_flow.next_step_path(step)).to eq(expected_path)
        end
      end
    end

    context "trainee" do
      let(:form) { build(:trainee_form, :eligible) }

      [
        [ApplicationRouteStep, "/step/trainee-details"],
        [TraineeDetailsStep, "/step/start-date"],
        [StartDateStep, "/step/subject"],
        [SubjectStep, "/step/visa"],
        [VisaStep, "/step/entry-date"],
        [EntryDateStep, "/step/personal-details"],
        [PersonalDetailsStep, "/step/employment-details"],
        [EmploymentDetailsStep, "/summary"],
      ].each do |(step_class, expected_path)|
        it "#{step_class} -> #{expected_path}" do
          step = step_class.new(form)
          expect(step_flow.next_step_path(step)).to eq(expected_path)
        end
      end
    end
  end

  describe "previous_step_path" do
    context "teacher" do
      let(:form) { build(:teacher_form) }

      [
        [ApplicationRouteStep, nil],
        [SchoolDetailsStep, "/step/application-route"],
        [ContractDetailsStep, "/step/school-details"],
        [StartDateStep, "/step/contract-details"],
        [SubjectStep, "/step/start-date"],
        [VisaStep, "/step/subject"],
        [EntryDateStep, "/step/visa"],
        [PersonalDetailsStep, "/step/entry-date"],
        [EmploymentDetailsStep, "/step/personal-details"],
      ].each do |step_class, expected_path|
        it "#{step_class} -> #{expected_path}" do
          step = step_class.new(form)
          expect(step_flow.previous_step_path(step)).to eq(expected_path)
        end
      end
    end

    context "trainee" do
      let(:form) { build(:trainee_form) }

      [
        [ApplicationRouteStep, nil],
        [TraineeDetailsStep, "/step/application-route"],
        [StartDateStep, "/step/trainee-details"],
        [SubjectStep, "/step/start-date"],
        [VisaStep, "/step/subject"],
        [EntryDateStep, "/step/visa"],
        [PersonalDetailsStep, "/step/entry-date"],
        [EmploymentDetailsStep, "/step/personal-details"],
      ].each do |(step_class, expected_path)|
        it "#{step_class} -> #{expected_path}" do
          step = step_class.new(form)
          expect(step_flow.previous_step_path(step)).to eq(expected_path)
        end
      end
    end
  end
end
