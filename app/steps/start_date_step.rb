class StartDateStep < BaseStep
  ROUTE_KEY = "start-date".freeze

  REQUIRED_FIELDS = %i[start_date].freeze

  def configure_step
    @question = t("steps.start_date.question")
    @question_type = :date
  end
end
