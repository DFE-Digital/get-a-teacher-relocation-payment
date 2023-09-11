require "rails_helper"

RSpec.describe DeleteStaleFormsJob do
  subject(:job) { described_class.new }

  describe "perform" do
    let(:stale_form) { build(:form, created_at: 25.hours.ago) }
    let(:form) { build(:form) }

    before do
      stale_form.save
      form.save
    end

    it { expect { job.perform }.to change(Form, :count).from(2).to(1) }

    context "delete stale forms" do
      before { job.perform }

      it { expect { Form.find(id: stale_form.id) }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end
end
