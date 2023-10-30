class ApplicationsIndexQuery
  delegate :to_sql, to: :query

  def execute
    ApplicationRecord.connection.execute(to_sql)
  end

  def query
    @query ||= applications
                 .project(projection)
                 .order(applications[:created_at].asc)
  end

  def projection
    [
      applications[:id],
      row_number.as("application_index"),
    ]
  end

  def row_number
    Arel::Nodes::Over.new(
      Arel::Nodes::NamedFunction.new("ROW_NUMBER", []),
      Arel.sql("(ORDER BY created_at ASC)"),
    )
  end

private

  def applications
    Application.arel_table
  end
end
