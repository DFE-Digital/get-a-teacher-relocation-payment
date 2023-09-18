# rubocop:disable Rails/SkipsModelValidations
class ChangeApplicationUrn < ActiveRecord::Migration[7.0]
  def up
    execute("CREATE SEQUENCE urn_sequence;")

    add_column :applications, :urn_prefix, :string, null: false, default: "IRP"
    add_column :applications, :urn_code, :string
    add_column :applications, :urn_suffix, :string, unique: true, default: -> { "nextval('urn_sequence')" }

    # migrate existing applications
    code = ->(app) { app.application_route == "teacher" ? "TE" : "ST" }
    suffix = ->(app) { app.urn[5..] }
    data = Application.all.map do |app|
      app.attributes.merge(urn_prefix: "IRP", urn_code: code[app], urn_suffix: suffix[app])
    end
    Application.upsert_all(data) if data.present?
  end

  def down
    remove_column :applications, :urn_prefix
    remove_column :applications, :urn_code
    remove_column :applications, :urn_suffix

    execute("DROP SEQUENCE urn_sequence;")
  end
end
# rubocop:enable Rails/SkipsModelValidations
