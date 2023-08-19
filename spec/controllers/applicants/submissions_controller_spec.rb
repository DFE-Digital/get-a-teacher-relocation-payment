require "rails_helper"

module Applicants
  RSpec.describe SubmissionsController do
    describe "GET #show" do
      let(:application) { create(:application, :submitted) }

      before do
        allow(controller).to receive(:current_application).and_return(application)
      end

      it "resets the session's application_id to nil" do
        session[:application_id] = application.id

        get :show

        expect(session[:application_id]).to be_nil
      end
    end
  end
end
