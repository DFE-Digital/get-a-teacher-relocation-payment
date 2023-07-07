# frozen_string_literal: true

require "rails_helper"

describe "trainee route: completing the form" do
  include_context "with common application form steps"
  include_context "with common application form assertions"

  describe "navigating forward" do
    context "eligible users" do
      it "submits an application" do
        when_i_start_the_form
        and_i_complete_application_route_question_with(option: "salaried_trainee")
        and_i_complete_the_trainee_employment_conditions
        and_i_enter_my_contract_start_date
        and_i_select_my_subject("salaried_trainee")
        and_i_select_my_visa_type
        and_i_enter_my_entry_date("salaried_trainee")
        and_i_enter_my_personal_details
        and_i_enter_my_employment_details

        then_the_application_is_submitted_successfully
      end
    end

    context "non-eligible users" do
      it "shows ineligible page" do
        when_i_start_the_form
        and_i_complete_application_route_question_with(option: "salaried_trainee")
        and_i_complete_the_trainee_employment_conditions(choose: "No")

        expect(page).to have_text("We’re sorry")
                          .and have_text("If you are enrolled on a fee-paying teacher training course")
      end
    end
  end

  describe "navigating backwards" do
    it "allows the user to navigate back to the previous pages" do
      when_i_start_the_form
      and_i_complete_application_route_question_with(option: "salaried_trainee")
      and_i_complete_the_trainee_employment_conditions
      and_i_enter_my_contract_start_date
      and_i_select_my_subject("salaried_trainee")
      and_i_select_my_visa_type
      and_i_enter_my_entry_date("salaried_trainee")
      and_i_enter_my_personal_details

      # We're now on the employment details page
      # We start going backwards
      when_i_click_the_back_link
      assert_i_am_in_the_personal_details_question

      when_i_click_the_back_link
      assert_i_am_in_the_entry_date_question("salaried_trainee")

      when_i_click_the_back_link
      assert_i_am_in_the_visa_type_question

      when_i_click_the_back_link
      assert_i_am_in_the_subject_question("salaried_trainee")

      when_i_click_the_back_link
      assert_i_am_in_the_contract_start_date_question

      when_i_click_the_back_link
      assert_i_am_in_the_trainee_employment_conditions_question

      when_i_click_the_back_link
      assert_i_am_in_the_application_route_question
    end
  end
end
