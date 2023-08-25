require "rails_helper"

module Applicants
  RSpec.describe "Question for Contract Start Date", pending: "will be removed" do
    describe "POST create" do
      let(:valid_params) do
        {
          applicants_contract_start_date: {
            "contract_start_date(3i)" => "1",
            "contract_start_date(2i)" => "1",
            "contract_start_date(1i)" => "2023",
          },
        }
      end

      context "when it is not a teacher" do
        before do
          set_user_type("salaried_trainee")
        end

        it "redirects to the new subject path if it is eligible" do
          allow(Policies::ContractStartDate).to receive(:eligible?).and_return(true)
          post "/applicants/contract_start_dates", params: valid_params

          expect(response).to redirect_to(new_applicants_subject_path)
        end
      end

      context "when it is a teacher" do
        before do
          set_user_type("teacher")
        end

        context "with valid params" do
          it "redirects to the new subject path if it is eligible" do
            allow(Policies::ContractStartDate).to receive(:eligible?).and_return(true)
            post "/applicants/contract_start_dates", params: valid_params

            expect(response).to redirect_to(new_applicants_subject_path)
          end

          it "redirects to the ineligible path if it is not eligible" do
            allow(Policies::ContractStartDate).to receive(:eligible?).and_return(false)
            post "/applicants/contract_start_dates", params: valid_params

            expect(response).to redirect_to(ineligible_path)
          end
        end

        context "with invalid params" do
          let(:invalid) do
            {
              applicants_contract_start_date: {
                "contract_start_date(3i)" => "31",
                "contract_start_date(2i)" => "31",
                "contract_start_date(1i)" => "2023",
              },
            }
          end

          it "renders the new template" do
            post "/applicants/contract_start_dates", params: invalid

            expect(response.body).to include("Enter the start date of your contract")
          end
        end
      end

      # rubocop:disable RSpec/AnyInstance
      def set_user_type(route_type)
        # TODO: Remove this stub when we have a better way of storing the route type on the DB
        # The current implementation of the application route is to store it in the session,
        # this is not ideal and should be changed to be stored in the database. For now we are
        # stubbing the session to return the route type, but this is temporary.
        application = create(:application, application_route: route_type, urn: nil)
        allow_any_instance_of(ContractStartDatesController).to receive(:session).and_return(
          { "application_id" => application.id },
        )
      end
      # rubocop:enable RSpec/AnyInstance
    end
  end
end
