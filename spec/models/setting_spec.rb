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

RSpec.describe Setting do
  describe ".current" do
    it "returns the current setting" do
      setting = create(:setting)

      expect(described_class.current).to eq(setting)
    end

    it "creates a new setting if none exists" do
      expect { described_class.current }.to change(described_class, :count).by(1)
    end
  end
end
