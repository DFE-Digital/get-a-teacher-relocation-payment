require "rails_helper"

RSpec.describe SubmitForm do
  subject(:service) { described_class.new(form) }

  let(:form) { build(:form, :complete, :eligible) }

  describe "valid?" do
    context "returns true when form complete and eligible" do
      let(:form) { build(:form, :complete, :eligible) }

      it { expect(service).to be_valid }
    end

    context "return false when form incomplete and eligible" do
      let(:form) { build(:form, :complete, :eligible, passport_number: nil) }

      it { expect(service).not_to be_valid }
    end

    context "return false when form complete and ineligible" do
      let(:form) { build(:form, :complete, :eligible, application_route: "other") }

      it { expect(service).not_to be_valid }
    end
  end

  describe "success?" do
    context "returns false when form is not submitted" do
      it { expect(service).not_to be_success }
    end

    context "returns true when form is submitted" do
      before { service.submit_form! }

      it { expect(service).to be_success }
    end
  end

  describe "submit_form!" do
    context "creates records" do
      before { form.save }

      it { expect { service.submit_form! }.to change(School, :count).by(1) }
      it { expect { service.submit_form! }.to change(Applicant, :count).by(1) }
      it { expect { service.submit_form! }.to change(Address, :count).by(2) }
      it { expect { service.submit_form! }.to change(Application, :count).by(1) }
      it { expect { service.submit_form! }.to change(Form, :count).from(1).to(0) }

      context "applicant email" do
        before do
          allow(Urn).to receive(:generate).and_return(urn)
        end

        let(:urn) { "SOMEURN" }
        let(:expected_email_params) do
          {
            params: {
              email: form.email_address,
              urn: urn,
            },
            args: [],
          }
        end

        it "enqueue mail job" do
          expect { service.submit_form! }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
            .with("GovukNotifyMailer", "application_submission", "deliver_now", expected_email_params)
        end
      end
    end
  end
end
