require "rails_helper"

RSpec.describe "Submissions" do
  describe "GET /summary" do
    context "when no form_id in session"
    it "redirects to root_path" do
      get "/summary"
      expect(response).to have_http_status(:found)
    end
  end

  describe "POST /summary" do
    let(:service) { SubmitForm.new(form, remote_ip) }
    let(:form) { build(:form) }
    let(:remote_ip) { "127.0.0.1" }

    before do
      allow_any_instance_of(SubmissionController).to receive(:check_service_open!).and_return(true)
      allow_any_instance_of(SubmissionController).to receive(:current_form).and_return(form)
      allow(SubmitForm).to receive(:call).and_return(service)
    end

    it "records ip address" do
      post "/summary"
      expect(SubmitForm).to have_received(:call).with(form, remote_ip)
    end
  end
end
