# frozen_string_literal: true

RSpec.shared_context "with common application form assertions" do
  def assert_i_am_in_the_subject_question(route)
    expect(page).to have_text(I18n.t("steps.subject.question.#{route}"))
  end

  def assert_i_am_in_the_contract_start_date_question
    expect(page).to have_text(I18n.t("steps.start_date.question"))
  end

  def assert_i_am_in_the_employment_details_question
    expect(page).to have_text(I18n.t("steps.employment_details.question"))
  end

  def assert_i_am_in_the_personal_details_question
    expect(page).to have_text(I18n.t("steps.personal_details.question"))
  end

  def assert_i_am_in_the_entry_date_question(route)
    expect(page).to have_text(I18n.t("steps.entry_date.question.#{route}"))
  end

  def assert_i_am_in_the_visa_type_question
    expect(page).to have_text(I18n.t("steps.visa.question"))
  end

  def assert_i_am_in_the_application_route_question
    expect(page).to have_text(I18n.t("steps.application_route.question"))
  end

  def assert_i_am_in_the_trainee_employment_conditions_question
    expect(page).to have_text(I18n.t("steps.trainee_details.question"))
  end

  def and_i_complete_the_state_school_question
    assert_i_am_in_the_state_school_question

    choose_yes
  end

  def and_i_complete_the_contract_details_question
    assert_i_am_on_the_contract_details_question

    choose_yes
  end

  def then_i_can_see_the_landing_page
    expect(page).to have_text("Apply for the international relocation payment")
  end

  def assert_i_am_in_the_state_school_question
    expect(page).to have_text(I18n.t("steps.school_details.question"))
  end

  def assert_i_am_on_the_contract_details_question
    expect(page).to have_text(I18n.t("steps.contract_details.question"))
  end
end
