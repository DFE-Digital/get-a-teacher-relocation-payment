require "rails_helper"

module Applicants
  RSpec.describe "Question for Personal details" do
    describe "POST create" do
      let(:valid_params) do
        {
          applicants_personal_detail: {
            "given_name" => "John",
            "family_name" => "Doe",
            "email_address" => "john@email.com",
            "phone_number" => "07702496000",
            "sex" => "male",
            "passport_number" => "123456789",
            "nationality" => "British National Overseas",
            "address_line_1" => "7 McLeud",
            "address_line_2" => "second line",
            "city" => "London",
            "postcode" => "E1 8QS",
            "date_of_birth(3i)" => "1",
            "date_of_birth(2i)" => "1",
            "date_of_birth(1i)" => "1990",
          },
        }
      end

      before do
        set_applicant_route!
      end

      context "with valid params" do
        it "redirects to the employment details path" do
          post "/applicants/personal_details", params: valid_params

          expect(response).to redirect_to(new_applicants_employment_detail_path)
        end

        it "creates an Applicant" do
          expect {
            post "/applicants/personal_details", params: valid_params
          }.to change(Applicant, :count).by(1)
        end
      end

      context "with invalid params" do
        let(:invalid) do
          {
            applicants_personal_detail: {
              "school_name" => "Alexander McLeod Primary School",
              "school_postcode" => "E1 8QS",
              "school_headteacher_name" => "Mr. Headteacher",
            },
          }
        end

        it "renders the new template" do
          post "/applicants/personal_details", params: invalid

          expect(response.body).to include("Personal information")
        end
      end

      # rubocop:disable RSpec/AnyInstance
      def set_applicant_route!
        # The current implementation users the user session to store attributes, which
        # is not ideal and should be changed next. For now we are stubbing the session
        # to return the applicant details.
        application = create(:application, urn: nil)
        allow_any_instance_of(PersonalDetailsController).to receive(:session).and_return({
          "application_id" => application.id,
        })
      end
      # rubocop:enable RSpec/AnyInstance
    end
  end
end
