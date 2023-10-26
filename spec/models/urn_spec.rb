# frozen_string_literal: true

require "rails_helper"

RSpec.describe Urn do
  subject(:urn) { described_class.next(applicant_type) }

  describe ".next" do
    context 'when applicant type is "teacher"' do
      let(:applicant_type) { "teacher" }

      it "generates a URN with the correct prefix and suffix" do
        expect(urn).to match(/^IRPTE[0-9]{5}$/)
      end

      it "generates a Urn with a suffix of only characters in the CHARSET" do
        charset = %w[0 1 2 3 4 5 6 7 8 9]

        expect(urn[5..9].chars).to all(be_in(charset))
      end
    end

    context 'when applicant type is "salaried_trainee"' do
      let(:applicant_type) { "salaried_trainee" }

      it "generates a URN with the correct prefix and suffix" do
        expect(urn).to match(/^IRPST[0-9]{5}$/)
      end
    end

    context "when an invalid applicant type is provided" do
      let(:applicant_type) { "invalid_type" }

      it "raises an ArgumentError" do
        expect { urn }.to raise_error(ArgumentError, 'Invalid route: invalid_type, must be one of ["teacher", "salaried_trainee"]')
      end
    end
  end
end
