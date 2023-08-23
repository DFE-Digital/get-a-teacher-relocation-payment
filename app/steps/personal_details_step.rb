class PersonalDetailsStep < BaseStep
  ROUTE_KEY = "personal-details".freeze

  REQUIRED_FIELDS = %i[
    email_address
    family_name
    given_name
    phone_number
    date_of_birth
    address_line_1
    city
    postcode
    sex
    nationality
    passport_number
    student_loan
  ].freeze

  OPTIONAL_FIELDS = %i[
    middle_name
    address_line_2
  ].freeze

  SEX_OPTIONS = %w[female male].freeze

  validates :phone_number, phone: { possible: true, types: %i[voip mobile] }
  validates :nationality, inclusion: { in: NATIONALITIES }
  validates :sex, inclusion: { in: SEX_OPTIONS }
  validates :postcode, postcode: true
  validate :date_of_birth_not_in_future
  validate :age_less_than_maximum
  validate :minimum_age

  def configure_step
    @question = t("steps.personal_details.question")
    @question_type = :multi
    @student_loan_valid_answers = [
      Answer.new(value: true, label: t("steps.contract_details.answers.yes.text")),
      Answer.new(value: false, label: t("steps.contract_details.answers.no.text")),
    ]
  end

  attr_reader :student_loan_valid_answers

  def template
    "step/personal_details"
  end

private

  def date_of_birth_not_in_future
    return unless date_of_birth.present? && date_of_birth > Date.current

    errors.add(:date_of_birth, "cannot be in the future")
  end

  def age_less_than_maximum
    return unless date_of_birth.present? && (Date.current.year - date_of_birth.year) >= MAX_AGE

    errors.add(:date_of_birth)
  end

  def minimum_age
    # rubocop:disable Rails/Blank
    return unless date_of_birth.present?
    # rubocop:enable Rails/Blank

    errors.add(:date_of_birth, "must be at least #{MIN_AGE} years") if date_of_birth > MIN_AGE.years.ago.to_date
  end

  MAX_AGE = 80
  MIN_AGE = 22
  private_constant :MAX_AGE, :MIN_AGE
end
