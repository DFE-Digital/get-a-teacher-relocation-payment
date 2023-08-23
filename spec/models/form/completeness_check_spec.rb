require "rails_helper"

RSpec.describe Form::CompletenessCheck do
  subject(:check) { described_class.new(form) }

  describe "failure_reason" do
    context "when complete" do
      let(:form) { build(:form, :complete) }

      it { expect(check.failure_reason).to be_nil }
    end

    context "when boolean field hold false value" do
      let(:form) { build(:form, :complete, student_loan: false) }

      it { expect(check.failure_reason).to be_nil }
    end

    context "when incomplete" do
      context "for teacher" do
        %i[
          application_route
          state_funded_secondary_school
          one_year
          visa_type
          start_date
          date_of_entry
          subject
          date_of_birth
          email_address
          family_name
          given_name
          phone_number
          sex
          address_line_1
          city
          postcode
          passport_number
          nationality
          student_loan
          school_headteacher_name
          school_name
          school_address_line_1
          school_city
          school_postcode
        ].each do |field|
          it "when #{field} missing" do
            form = build(:teacher_form, :complete, field => nil)
            expected = "missing fields: #{field}"
            error = described_class.new(form).failure_reason
            expect(error).to eq(expected)
          end
        end
      end

      context "for trainee" do
        %i[
          application_route
          state_funded_secondary_school
          visa_type
          start_date
          date_of_entry
          subject
          date_of_birth
          email_address
          family_name
          given_name
          phone_number
          sex
          address_line_1
          city
          postcode
          passport_number
          nationality
          student_loan
          school_headteacher_name
          school_name
          school_address_line_1
          school_city
          school_postcode
        ].each do |field|
          it "when #{field} missing" do
            form = build(:trainee_form, :complete, field => nil)
            expected = "missing fields: #{field}"
            error = described_class.new(form).failure_reason
            expect(error).to eq(expected)
          end
        end
      end
    end
  end

  describe "passed?" do
    context "complete form" do
      let(:form) { build(:form, :complete) }

      it { expect(check).to be_passed }
    end

    context "incomplete form" do
      let(:form) { build(:form) }

      it { expect(check).not_to be_passed }
    end
  end

  describe "failed?" do
    context "complete form" do
      let(:form) { build(:form, :complete) }

      it { expect(check).not_to be_failed }
    end

    context "incomplete form" do
      let(:form) { build(:form) }

      it { expect(check).to be_failed }
    end
  end
end
