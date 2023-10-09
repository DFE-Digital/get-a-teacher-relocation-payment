require "rails_helper"

RSpec.describe SubmitForm do
  subject(:service) { described_class.new(form, remote_ip) }

  let(:form) { build(:form, :complete, :eligible) }
  let(:remote_ip) { "204.65.54.6" }

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
      before do
        form.save
        service.submit_form!
      end

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

      context "school attributes" do
        before do
          allow(School).to receive(:create!).and_return(school)

          service.submit_form!
        end

        let(:school) { build(:school) }
        let(:expected_school_data) do
          {
            name: form.school_name,
            headteacher_name: form.school_headteacher_name,
            address_attributes: {
              address_line_1: form.school_address_line_1,
              address_line_2: form.school_address_line_2,
              city: form.school_city,
              postcode: form.school_postcode,
            },
          }
        end

        it { expect(School).to have_received(:create!).with(expected_school_data) }
      end

      context "applicants attributes" do
        before do
          allow(Applicant).to receive(:create!).and_return(applicant)

          service.submit_form!
        end

        let(:applicant) { build(:applicant) }
        let(:expected_applicant_data) do
          {
            ip_address: service.ip_address,
            given_name: form.given_name,
            middle_name: form.middle_name,
            family_name: form.family_name,
            email_address: form.email_address,
            phone_number: form.phone_number,
            date_of_birth: form.date_of_birth,
            sex: form.sex,
            passport_number: form.passport_number,
            nationality: form.nationality,
            student_loan: form.student_loan,
            address_attributes: {
              address_line_1: form.address_line_1,
              address_line_2: form.address_line_2,
              city: form.city,
              postcode: form.postcode,
            },
            school: kind_of(School),
          }
        end

        it { expect(Applicant).to have_received(:create!).with(expected_applicant_data) }
      end

      context "applications attributes" do
        before do
          allow(Application).to receive(:create!).and_return(application)

          service.submit_form!
        end

        let(:application) { build(:application) }
        let(:expected_application_data) do
          {
            applicant: kind_of(Applicant),
            application_date: Date.current.to_s,
            application_route: form.application_route,
            application_progress: kind_of(ApplicationProgress),
            date_of_entry: form.date_of_entry,
            start_date: form.start_date,
            subject: SubjectStep.new(form).answer.formatted_value,
            urn: kind_of(String),
            visa_type: form.visa_type,
          }
        end

        it { expect(Application).to have_received(:create!).with(expected_application_data) }
      end

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
