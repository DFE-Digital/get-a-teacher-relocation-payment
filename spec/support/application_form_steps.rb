# frozen_string_literal: true

RSpec.shared_context "with common application form steps" do
  def then_the_application_is_submitted_successfully
    expect(page).to have_text("You have successfully submitted")
    expect(Application.count).to eq(1)
    expect(Applicant.count).to eq(1)
    expect(Address.count).to eq(2)
    expect(ApplicationProgress.count).to eq(1)
    expect(School.count).to eq(1)
    expect(Application.last).to be_valid
  end

  def when_i_start_the_form
    visit(root_path)

    click_link("Start")
  end

  def when_i_click_the_back_link
    click_link("Back")
  end

  def when_i_click_the_continue_button
    click_button("Continue")
  end

  def and_i_complete_application_route_question_with(option:)
    raise "Unexpected option: #{option}" unless %w[salaried_trainee teacher].include?(option)

    choose(option:)

    click_button("Continue")
  end

  def and_i_select_my_subject(route)
    assert_i_am_in_the_subject_question(route)

    choose("Physics")

    click_button("Continue")
  end

  def and_i_select_my_visa_type
    assert_i_am_in_the_visa_type_question

    select("Family visa")

    click_button("Continue")
  end

  def and_i_enter_my_entry_date(route)
    assert_i_am_in_the_entry_date_question(route)

    fill_in("Day", with: 12)
    fill_in("Month", with: 6)
    fill_in("Year", with: 2023)

    click_button("Continue")
  end

  def and_i_enter_my_personal_details
    assert_i_am_in_the_personal_details_question

    fill_in("personal_details_step[given_name]", with: "Bob")
    fill_in("personal_details_step[family_name]", with: "Robertson")
    fill_in("personal_details_step[email_address]", with: "test@example.com")
    fill_in("personal_details_step[phone_number]", with: "01234567890")
    fill_in("Day", with: 1)
    fill_in("Month", with: 1)
    fill_in("Year", with: 1990)
    fill_in("personal_details_step[phone_number]", with: "01234567890")
    fill_in("personal_details_step[address_line_1]", with: "12 Park Gardens")
    fill_in("personal_details_step[address_line_2]", with: "Office 20")
    fill_in("personal_details_step[city]", with: "London")
    fill_in("personal_details_step[postcode]", with: "AS1 1AA")
    select("Senegalese")
    choose("Male")
    fill_in("personal_details_step[passport_number]", with: "000")
    choose("No")

    click_button("Continue")
  end

  def and_i_enter_my_employment_details
    assert_i_am_in_the_employment_details_question

    fill_in("employment_details_step[school_headteacher_name]", with: "Mr Headteacher")
    fill_in("employment_details_step[school_name]", with: "School name")
    fill_in("employment_details_step[school_address_line_1]", with: "1, McSchool Street")
    fill_in("employment_details_step[school_address_line_2]", with: "Schoolville")
    fill_in("employment_details_step[school_city]", with: "Schooltown")
    fill_in("employment_details_step[school_postcode]", with: "SC1 1AA")

    click_button("Continue")
  end

  def and_i_submit_the_application
    click_button("Submit Application")
  end

  def choose_yes
    choose("Yes")

    click_button("Continue")
  end

  def choose_no
    choose("No")

    click_button("Continue")
  end

  def and_i_enter_my_contract_start_date
    assert_i_am_in_the_contract_start_date_question

    fill_in("Day", with: 12)
    fill_in("Month", with: 7)
    fill_in("Year", with: 2023)

    click_button("Continue")
  end

  def and_i_complete_the_trainee_employment_conditions(choose: "Yes")
    assert_i_am_in_the_trainee_employment_conditions_question

    choose == "Yes" ? choose_yes : choose_no
  end

  def and_i_complete_the_trainee_contract_details_question
    choose_yes
  end

  def and_i_enter_an_invalid_date
    fill_in("Day", with: 31)
    fill_in("Month", with: 2)
    fill_in("Year", with: 2019)

    click_button("Continue")
  end
end
