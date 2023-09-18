class CreateUrnSequence < ActiveRecord::Migration[7.0]
  def up
    execute("CREATE SEQUENCE urn_sequence;")
  end

  def down
    execute("DROP SEQUENCE urn_sequence;")
  end
end
