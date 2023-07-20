# == Schema Information
#
# Table name: settings
#
#  id                 :bigint           not null, primary key
#  service_end_date   :date
#  service_start_date :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
require "rails_helper"

RSpec.describe AppSettings do
  describe ".current" do
    before do
      described_class.delete_all
    end

    it "returns the current setting" do
      expect(described_class.current).to eq(described_class.first)
    end

    it "creates a new setting if none exists" do
      expect { described_class.current }.to change(described_class, :count).by(1)
    end

    it "does not allow default constructor" do
      expect { described_class.new }.to raise_error(NoMethodError)
    end
  end
end
