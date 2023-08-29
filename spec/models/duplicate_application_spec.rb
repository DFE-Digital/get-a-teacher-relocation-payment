# == Schema Information
#
# Table name: duplicate_applications
#
#  id                              :bigint
#  application_date                :date
#  application_route               :string
#  date_of_entry                   :date
#  duplicate_email                 :text
#  duplicate_passport              :text
#  duplicate_phone                 :text
#  home_office_csv_downloaded_at   :datetime
#  payroll_csv_downloaded_at       :datetime
#  standing_data_csv_downloaded_at :datetime
#  start_date                      :date
#  subject                         :string
#  urn                             :string
#  visa_type                       :string
#  created_at                      :datetime
#  updated_at                      :datetime
#  applicant_id                    :bigint
#
require "rails_helper"

RSpec.describe DuplicateApplication do
  describe ".search" do
    it "returns duplicate applications that match the email" do
      first_dup = create(:applicant, email_address: "test@example.com")
      second_dup = create(:applicant, email_address: "test@example.com")
      application_one = create(:application, applicant: first_dup)
      application_two = create(:application, applicant: second_dup)

      expect(described_class.search("test@example.com").map(&:id)).to include(application_one.id, application_two.id)
    end

    it "returns duplicate applications that match the phone number" do
      first_dup = create(:applicant, phone_number: "0987654321")
      second_dup = create(:applicant, phone_number: "0987654321")
      application_one = create(:application, applicant: first_dup)
      application_two = create(:application, applicant: second_dup)

      expect(described_class.search("0987654321").map(&:id)).to include(application_one.id, application_two.id)
    end

    it "returns duplicate applications that match the passport number" do
      first_dup = create(:applicant, passport_number: "CD789012")
      second_dup = create(:applicant, passport_number: "CD789012")
      application_one = create(:application, applicant: first_dup)
      application_two = create(:application, applicant: second_dup)

      expect(described_class.search("CD789012").map(&:id)).to include(application_one.id, application_two.id)
    end

    it "returns no results when the search term does not match any field" do
      create_list(:application, 3)
      expect(described_class.search("no_match")).to be_empty
    end
  end
end
