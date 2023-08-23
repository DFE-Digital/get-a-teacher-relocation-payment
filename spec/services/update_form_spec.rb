require "rails_helper"

RSpec.describe UpdateForm do
  subject(:update_form) { described_class.new(step, params) }

  let(:form) { build(:form) }
  let(:step) { ApplicationRouteStep.new(form) }
  let(:params) { { "application_route" => application_route } }
  let(:application_route) { "teacher" }

  describe "valid?" do
    context "for vaild step" do
      it { expect(update_form).to be_valid }
    end

    context "for invaild step" do
      let(:application_route) { "dentist" }

      it { expect(update_form).not_to be_valid }
    end
  end

  describe "success?" do
    before { update_form.valid? }

    context "for vaild step" do
      it { expect(update_form).to be_success }
    end

    context "for invaild step" do
      let(:application_route) { "dentist" }

      it { expect(update_form).not_to be_success }
    end
  end

  describe "update_form!" do
    it "updates the form" do
      expect(form).to receive(:update).with(params)
      update_form.update_form!
    end
  end
end
