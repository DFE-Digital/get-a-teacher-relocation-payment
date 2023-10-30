class FindApplicationIndexQuery
  delegate :to_sql, to: :query
  attr_reader :application_id

  def initialize(application_id:)
    @application_id = application_id
  end

  def execute
    ApplicationRecord.connection.execute(to_sql)
  end

  def query
    @query ||= manager
                 .project(projection)
                 .from(from_clause)
                 .where(where_clause)
  end

  def projection
    [Arel.star]
  end

  def from_clause
    ApplicationsIndexQuery.new.query.as("list")
  end

  def where_clause
    Arel.sql("list.id").eq(application_id)
  end

private

  def manager
    @manager ||= Arel::SelectManager.new(Arel::Table.engine)
  end
end
