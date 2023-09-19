class AverageAgeQuery
  def initialize(relation = Applicant.all)
    @relation = relation.joins(:application).merge(Application.all)
  end

  def call
    @relation.average("EXTRACT(YEAR FROM AGE(date_of_birth))").to_i
  end
end
