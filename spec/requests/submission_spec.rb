require "rails_helper"

RSpec.describe "Submissions" do
  describe "GET /summary" do
    context "when no form_id in session"
    it "redirects to root_path" do
      get "/summary"
      expect(response).to have_http_status(:found)
    end
  end
end
