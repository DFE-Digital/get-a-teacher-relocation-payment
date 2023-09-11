# frozen_string_literal: true

require "rails_helper"

describe "Dashboard" do
  include AdminHelpers

  it "shows the Total Applications widget" do
    given_there_are_5_applications
    given_i_am_signed_as_an_admin
    when_i_am_in_the_dashboard_page
    then_i_can_see_the_applications_widget
  end

  it "shows the Total Rejections widget" do
    given_there_are_rejected_applications
    given_i_am_signed_as_an_admin
    when_i_am_in_the_dashboard_page
    then_i_can_see_the_total_rejections_widget
  end

  it "shows the Average Age widget" do
    given_there_are_3_applicants_with_ages
    given_i_am_signed_as_an_admin
    when_i_am_in_the_dashboard_page
    then_i_can_see_the_average_age_widget
  end

  it "shows the Total Paid widget" do
    given_there_are_paid_applications
    given_i_am_signed_as_an_admin
    when_i_am_in_the_dashboard_page
    then_i_can_see_the_total_paid_widget
  end

  it "shows the Route Breakdown widget" do
    given_there_are_few_applications
    given_i_am_signed_as_an_admin
    when_i_am_in_the_dashboard_page
    then_i_can_see_the_route_breakdown_widget
  end

  it "shows the Subject Breakdown widget" do
    given_there_are_few_applications
    given_i_am_signed_as_an_admin
    when_i_am_in_the_dashboard_page
    then_i_can_see_the_subject_breakdown_widget
  end

  it "shows the Visa Breakdown widget" do
    given_there_are_few_applications_with_visas
    given_i_am_signed_as_an_admin
    when_i_am_in_the_dashboard_page
    then_i_can_see_the_visa_breakdown_widget
  end

  it "shows the Nationalities Breakdown widget" do
    given_there_are_few_applications_with_nationalities
    given_i_am_signed_as_an_admin
    when_i_am_in_the_dashboard_page
    then_i_can_see_the_nationalities_breakdown_widget
  end

  it "shows the Gender Breakdown widget" do
    given_there_are_few_applications
    given_i_am_signed_as_an_admin
    when_i_am_in_the_dashboard_page
    then_i_can_see_the_gender_breakdown_widget
  end

  it "shows the Rejection Reason Breakdown widget" do
    given_there_are_applications_with_rejection_reasons
    given_i_am_signed_as_an_admin
    when_i_am_in_the_dashboard_page
    then_i_can_see_the_rejection_reason_breakdown_widget
  end

  it "shows the Initial Checks Approval time widget" do
    given_there_are_applications_with_initial_checks
    given_i_am_signed_as_an_admin
    when_i_am_in_the_dashboard_page
    then_i_can_see_the_initial_checks_approval_average_time_widget
  end

  it "shows the Home Office Checks Approval time widget" do
    given_there_are_applications_with_home_office_checks
    given_i_am_signed_as_an_admin
    when_i_am_in_the_dashboard_page
    then_i_can_see_the_home_office_checks_time_widget
  end

  it "shows the School Checks Approval time widget" do
    given_there_are_applications_with_school_checks
    given_i_am_signed_as_an_admin
    when_i_am_in_the_dashboard_page
    then_i_can_see_the_school_checks_time_widget
  end

  it "shows the Banking Approval time widget" do
    given_there_are_applications_with_banking_approval
    given_i_am_signed_as_an_admin
    when_i_am_in_the_dashboard_page
    then_i_can_see_the_banking_approval_completed_time_widget
  end

  it "shows the Payment Confirmation time widget" do
    given_there_are_applications_with_payment_confirmation
    given_i_am_signed_as_an_admin
    when_i_am_in_the_dashboard_page
    then_i_can_see_the_payment_confirmation_time_widget
  end

  def given_there_are_5_applications
    create_list(:application, 5)
  end

  def given_there_are_few_applications
    create(:teacher_application, subject: "Languages")
    create(:teacher_application, subject: "General or combined science, including physics")
    create(:salaried_trainee_application, subject: "Physics")
  end

  def given_there_are_paid_applications
    application = create(:application)
    create_list(:application_progress, 2, :payment_confirmation_completed, application:)
  end

  def given_there_are_few_applications_with_nationalities
    create(:applicant, nationality: "Chadians", application: create(:application))
    create(:applicant, nationality: "Libians", application: create(:application))
    create(:applicant, nationality: "Uzbeks", application: create(:application))
    create(:applicant, nationality: "Mongolians", application: create(:application))
    create(:applicant, nationality: "Spaniards", application: create(:application))
  end

  def given_there_are_few_applications_with_visas
    create(:applicant, application: create(:application, visa_type: VisaStep::VALID_ANSWERS_OPTIONS[0]))
    create(:applicant, application: create(:application, visa_type: VisaStep::VALID_ANSWERS_OPTIONS[1]))
    create(:applicant, application: create(:application, visa_type: VisaStep::VALID_ANSWERS_OPTIONS[1]))
    create(:applicant, application: create(:application, visa_type: VisaStep::VALID_ANSWERS_OPTIONS[1]))
    create(:applicant, application: create(:application, visa_type: VisaStep::VALID_ANSWERS_OPTIONS[2]))
    create(:applicant, application: create(:application, visa_type: VisaStep::VALID_ANSWERS_OPTIONS[2]))
    create(:applicant, application: create(:application, visa_type: VisaStep::VALID_ANSWERS_OPTIONS[3]))
  end

  def given_there_are_rejected_applications
    application = create(:application)
    create_list(:application_progress, 2, :rejection_completed, application:)
  end

  def given_there_are_applications_with_rejection_reasons
    application = create(:application)
    create(:application_progress, :rejection_completed, application: application, rejection_reason: :suspected_fraud)
    create(:application_progress, :rejection_completed, application: application, rejection_reason: :ineligible_school)
    create(:application_progress, :rejection_completed, application: application, rejection_reason: :suspected_fraud)
  end

  def given_there_are_3_applicants_with_ages
    create(:applicant, date_of_birth: 35.years.ago, application: create(:application))
    create(:applicant, date_of_birth: 45.years.ago, application: create(:application))
    create(:applicant, date_of_birth: 52.years.ago, application: create(:application))
  end

  def given_there_are_applications_with_initial_checks
    create(:application_progress, :initial_checks_completed, application: build(:application),
                                                             created_at: 10.days.ago, initial_checks_completed_at: 5.days.ago)
    create(:application_progress, :initial_checks_completed, application: build(:application),
                                                             created_at: 20.days.ago, initial_checks_completed_at: 10.days.ago)
    create(:application_progress, :initial_checks_completed, application: build(:application),
                                                             created_at: 30.days.ago, initial_checks_completed_at: 15.days.ago)
  end

  def given_there_are_applications_with_home_office_checks
    create(:application_progress, :home_office_checks_completed, application: build(:application),
                                                                 initial_checks_completed_at: 10.days.ago, home_office_checks_completed_at: 5.days.ago)
    create(:application_progress, :home_office_checks_completed, application: build(:application),
                                                                 initial_checks_completed_at: 20.days.ago, home_office_checks_completed_at: 10.days.ago)
    create(:application_progress, :home_office_checks_completed, application: build(:application),
                                                                 initial_checks_completed_at: 30.days.ago, home_office_checks_completed_at: 15.days.ago)
  end

  def given_there_are_applications_with_school_checks
    create(:application_progress, :school_checks_completed, application: build(:application),
                                                            home_office_checks_completed_at: 10.days.ago, school_checks_completed_at: 5.days.ago)
    create(:application_progress, :school_checks_completed, application: build(:application),
                                                            home_office_checks_completed_at: 20.days.ago, school_checks_completed_at: 10.days.ago)
    create(:application_progress, :school_checks_completed, application: build(:application),
                                                            home_office_checks_completed_at: 30.days.ago, school_checks_completed_at: 15.days.ago)
  end

  def given_there_are_applications_with_banking_approval
    create(:application_progress, :payment_confirmation_completed, application: build(:application),
                                                                   school_checks_completed_at: 10.days.ago, banking_approval_completed_at: 5.days.ago)
    create(:application_progress, :payment_confirmation_completed, application: build(:application),
                                                                   school_checks_completed_at: 20.days.ago, banking_approval_completed_at: 10.days.ago)
    create(:application_progress, :payment_confirmation_completed, application: build(:application),
                                                                   school_checks_completed_at: 30.days.ago, banking_approval_completed_at: 15.days.ago)
  end

  def given_there_are_applications_with_payment_confirmation
    create(:application_progress, :payment_confirmation_completed, application: build(:application),
                                                                   banking_approval_completed_at: 10.days.ago, payment_confirmation_completed_at: 5.days.ago)
    create(:application_progress, :payment_confirmation_completed, application: build(:application),
                                                                   banking_approval_completed_at: 20.days.ago, payment_confirmation_completed_at: 10.days.ago)
    create(:application_progress, :payment_confirmation_completed, application: build(:application),
                                                                   banking_approval_completed_at: 30.days.ago, payment_confirmation_completed_at: 15.days.ago)
  end

  def when_i_am_in_the_dashboard_page
    visit(dashboard_path)
  end

  def then_i_can_see_the_applications_widget
    within ".kpi-widget.applications" do
      expect(page).to have_content("Applications")
      expect(page).to have_content("5")
    end
  end

  def then_i_can_see_the_total_rejections_widget
    within ".kpi-widget.rejections" do
      expect(page).to have_content("Rejections")
      expect(page).to have_content("2")
    end
  end

  def then_i_can_see_the_average_age_widget
    within ".kpi-widget.age" do
      expect(page).to have_content("Average age")
      expect(page).to have_content("44 years")
    end
  end

  def then_i_can_see_the_total_paid_widget
    within ".kpi-widget.paid" do
      expect(page).to have_content("Payment confirmations")
      expect(page).to have_content("2")
    end
  end

  def then_i_can_see_the_route_breakdown_widget
    within ".kpi-widget.routes" do
      expect(page).to have_content("Route")
      expect(page).to have_content("Teacher")
      expect(page).to have_content("2")
      expect(page).to have_content("Salaried Trainee")
      expect(page).to have_content("1")
    end
  end

  def then_i_can_see_the_subject_breakdown_widget
    within ".kpi-widget.subjects" do
      expect(page).to have_content("Subject")
      expect(page).to have_content("General or combined science, including physics")
      expect(page).to have_content("Languages")
      expect(page).to have_content("Physics")
      expect(page).to have_content("1")
    end
  end

  def then_i_can_see_the_visa_breakdown_widget
    within ".kpi-widget.visas" do
      expect(page).to have_content("Top 3 visa types")
      expect(page).to have_content(VisaStep::VALID_ANSWERS_OPTIONS[0])
      expect(page).to have_content(VisaStep::VALID_ANSWERS_OPTIONS[1])
      expect(page).to have_content(VisaStep::VALID_ANSWERS_OPTIONS[2])
      expect(page).not_to have_content(VisaStep::VALID_ANSWERS_OPTIONS[3])
      expect(page).to have_content("3")
      expect(page).to have_content("2")
      expect(page).to have_content("1")
    end
  end

  def then_i_can_see_the_nationalities_breakdown_widget
    within ".kpi-widget.nationalities" do
      expect(page).to have_content("Top 5 nationalities")
      expect(page).to have_content("Chadians")
      expect(page).to have_content("Libians")
      expect(page).to have_content("Uzbeks")
      expect(page).to have_content("Mongolians")
      expect(page).to have_content("Spaniards")
      expect(page).to have_content("1")
    end
  end

  def then_i_can_see_the_gender_breakdown_widget
    within ".kpi-widget.genders" do
      expect(page).to have_content("Sex")
      expect(page).to have_content("Male").or have_content("Female")
    end
  end

  def then_i_can_see_the_rejection_reason_breakdown_widget
    within ".kpi-widget.rejection-reasons" do
      expect(page).to have_content("Reasons for rejection")
      expect(page).to have_content("Suspected fraud")
      expect(page).to have_content("2")
      expect(page).to have_content("Ineligible school")
      expect(page).to have_content("1")
    end
  end

  def then_i_can_see_the_initial_checks_approval_average_time_widget
    within ".kpi-widget.initial-checks-average" do
      expect(page).to have_content("Initial checks")
      expect(page).to have_content("Average completion time")
      expect(page).to have_content("10 days")
      expect(page).to have_content("Min/Max")
      expect(page).to have_content("5 days/15 days")
    end
  end

  def then_i_can_see_the_home_office_checks_time_widget
    within ".kpi-widget.home-office-checks-average" do
      expect(page).to have_content("Home Office checks")
      expect(page).to have_content("Average completion time")
      expect(page).to have_content("10 days")
      expect(page).to have_content("Min/Max")
      expect(page).to have_content("5 days/15 days")
    end
  end

  def then_i_can_see_the_school_checks_time_widget
    within ".kpi-widget.school-checks-average" do
      expect(page).to have_content("School checks")
      expect(page).to have_content("Average completion time")
      expect(page).to have_content("10 days")
      expect(page).to have_content("Min/Max")
      expect(page).to have_content("5 days/15 days")
    end
  end

  def then_i_can_see_the_banking_approval_completed_time_widget
    within ".kpi-widget.banking-approval-average" do
      expect(page).to have_content("Bank details approved")
      expect(page).to have_content("Average completion time")
      expect(page).to have_content("10 days")
      expect(page).to have_content("Min/Max")
      expect(page).to have_content("5 days/15 days")
    end
  end

  def then_i_can_see_the_payment_confirmation_time_widget
    within ".kpi-widget.payment-confirmation-average" do
      expect(page).to have_content("Payment confirmation")
      expect(page).to have_content("Average completion time")
      expect(page).to have_content("10 days")
      expect(page).to have_content("Min/Max")
      expect(page).to have_content("5 days/15 days")
    end
  end
end
