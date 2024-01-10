class AverageAgeQuery
  def initialize(applications = Application.all)
    @relation = Applicant.all.joins(:application).merge(applications)
  end

  def call
    @relation.average("EXTRACT(YEAR FROM AGE(date_of_birth))").to_i
  end
end
