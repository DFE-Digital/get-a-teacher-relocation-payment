require "rails_helper"

RSpec.describe UpdateForm do
  subject(:update_form) { described_class.new(step, params) }

  let(:form) { build(:trainee_form) }
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

  describe "capture_form_analytics" do
    it "when the form has not changes not event is triggered" do
      expect(Event).not_to receive(:publish)

      update_form.capture_form_analytics
    end

    context "when the form has changes" do
      before { form.save }

      it "a created event is triggered" do
        expect(Event).to receive(:publish)
                           .with(
                             :created,
                             form,
                             hash_including(
                               "application_route" => [nil, "salaried_trainee"],
                               "id" => [nil, form.id],
                             ),
                           )
        update_form.capture_form_analytics
      end

      it "a updated event is triggered" do
        form.update(given_name: "foo")
        expect(Event).to receive(:publish).with(:updated, form, hash_including("given_name" => [nil, "foo"]))
        update_form.capture_form_analytics
      end
    end
  end
end
