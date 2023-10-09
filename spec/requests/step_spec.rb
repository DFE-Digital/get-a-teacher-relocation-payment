require "rails_helper"

RSpec.describe "Steps" do
  describe "GET /step/:name" do
    context "valid step name" do
      %w[
        application-route
        contract-details
        employment-details
        entry-date
        personal-details
        school-details
        start-date
        subject
        trainee-details
        visa
      ].each do |name|
        before do
          post(
            "/step/application-route",
            params: { application_route_step: { application_route: "teacher" } },
          )
        end

        it "returns the #{name} page" do
          get "/step/#{name}"
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context "invalid step name" do
      it "retuns a routing error" do
        expect { get "/step/admin" }.to raise_error(ActionController::RoutingError)
      end
    end
  end
end
