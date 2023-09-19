# frozen_string_literal: true

require "rails_helper"

RSpec.describe Urn do
  describe ".call" do
    subject(:urn) { described_class.call(application_route, base: 8) }

    context 'when applicant type is "teacher"' do
      let(:application_route) { "teacher" }

      it "generates a URN with the correct prefix and suffix" do
        expect(urn).to match(/^IRPTE[0-7]{43}$/)
      end

      it "generates a Urn with a suffix of only characters in the octal CHARSET" do
        charset = %w[0 1 2 3 4 5 6 7]

        expect(urn[5..47].chars).to all(be_in(charset))
      end
    end

    context 'when applicant type is "salaried_trainee"' do
      let(:application_route) { "salaried_trainee" }

      it "generates a URN with the correct prefix and suffix" do
        expect(urn).to match(/^IRPST[0-7]{43}$/)
      end
    end

    context "when an invalid applicant type is provided" do
      let(:application_route) { "invalid_type" }

      it "raises an ArgumentError" do
        expect { urn }.to raise_error(ArgumentError, 'invalid route invalid_type. Must be one of ["teacher", "salaried_trainee"]')
      end
    end
  end
end
