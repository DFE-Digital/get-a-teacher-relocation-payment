require "rails_helper"

RSpec.describe SubmitForm do
  subject(:service) { described_class.new(form) }

  let(:form) { build(:form, :complete, :eligible) }

  before do
    allow(GovukNotify::Client).to receive(:send_email)
  end

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
    end

    context "send confirmation email" do
      before { service.submit_form! }

      it { expect(GovukNotify::Client).to have_received(:send_email) }
    end
  end
end
