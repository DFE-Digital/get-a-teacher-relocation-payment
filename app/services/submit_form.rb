class SubmitForm
  def self.call(...)
    service = new(...)
    return service unless service.valid?

    service.submit_form!
    service
  end

  def initialize(form)
    @form = form
    @success = false
  end
  attr_reader :form, :application

  delegate :errors, to: :form

  def valid?
    form.validate_completeness
    form.validate_eligibility
    form.errors.blank?
  end

  def success?
    @success
  end

  def submit_form!
    create_application_records
    send_applicant_email
    @success = true
  end

private

  def create_application_records
    ActiveRecord::Base.transaction do
      create_school
      create_applicant
      create_application
      delete_form
    end
  end

  def create_school
    @school = School.create!(
      name: form.school_name,
      headteacher_name: form.school_headteacher_name,
      address_attributes: {
        address_line_1: form.school_address_line_1,
        address_line_2: form.school_address_line_2,
        city: form.school_city,
        postcode: form.school_postcode,
      },
    )
  end

  def create_applicant
    @applicant = Applicant.create!(
      given_name: form.given_name,
      middle_name: form.middle_name,
      family_name: form.family_name,
      email_address: form.email_address,
      phone_number: form.phone_number,
      date_of_birth: form.date_of_birth,
      sex: form.sex,
      passport_number: form.passport_number,
      nationality: form.nationality,
      student_loan: form.student_loan,
      address_attributes: {
        address_line_1: form.address_line_1,
        address_line_2: form.address_line_2,
        city: form.city,
        postcode: form.postcode,
      },
      school: @school,
    )
  end

  def create_application
    @application = Application.create!(
      applicant: @applicant,
      application_date: Date.current.to_s,
      application_route: form.application_route,
      application_progress: ApplicationProgress.new,
      date_of_entry: form.date_of_entry,
      start_date: form.start_date,
      subject: SubjectStep.new(form).answer.formatted_value,
      visa_type: form.visa_type,
      urn_prefix: "IRP",
      urn_code: urn_code,
    )
    @application.reload
    @application.assign_urn!
    @application
  end

  def urn_code
    return "TE" if form.teacher_route?

    "ST"
  end

  def delete_form
    form.destroy!
  end

  def send_applicant_email
    GovukNotifyMailer
      .with(
        email: @applicant.email_address,
        urn: application.urn,
      )
      .application_submission
      .deliver_later
  end
end
