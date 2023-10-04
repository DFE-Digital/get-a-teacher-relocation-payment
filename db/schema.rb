# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_10_03_024901) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "addressable_type", null: false
    t.bigint "addressable_id", null: false
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "city"
    t.string "postcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
  end

  create_table "app_settings", force: :cascade do |t|
    t.date "service_start_date"
    t.date "service_end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "applicants", force: :cascade do |t|
    t.text "given_name"
    t.text "family_name"
    t.text "email_address"
    t.text "phone_number"
    t.date "date_of_birth"
    t.text "nationality"
    t.text "sex"
    t.text "passport_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "school_id"
    t.string "middle_name"
    t.boolean "student_loan"
    t.string "ip_address"
    t.index ["school_id"], name: "index_applicants_on_school_id"
  end

  create_table "application_progresses", force: :cascade do |t|
    t.date "initial_checks_completed_at"
    t.boolean "visa_investigation_required", default: false, null: false
    t.date "home_office_checks_completed_at"
    t.boolean "school_investigation_required", default: false, null: false
    t.date "school_checks_completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "application_id"
    t.date "rejection_completed_at"
    t.date "payment_confirmation_completed_at"
    t.date "banking_approval_completed_at"
    t.text "rejection_details"
    t.integer "status", default: 0
    t.integer "rejection_reason"
  end

  create_table "applications", force: :cascade do |t|
    t.date "application_date"
    t.string "urn"
    t.bigint "applicant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subject"
    t.string "visa_type"
    t.date "date_of_entry"
    t.date "start_date"
    t.string "application_route"
    t.datetime "home_office_csv_downloaded_at"
    t.datetime "standing_data_csv_downloaded_at"
    t.datetime "payroll_csv_downloaded_at"
    t.index ["applicant_id"], name: "index_applications_on_applicant_id"
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "flipper_features", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true
  end

  create_table "flipper_gates", force: :cascade do |t|
    t.string "feature_key", null: false
    t.string "key", null: false
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true
  end

  create_table "forms", force: :cascade do |t|
    t.string "given_name"
    t.string "middle_name"
    t.string "family_name"
    t.string "email_address"
    t.string "phone_number"
    t.date "date_of_birth"
    t.string "nationality"
    t.string "sex"
    t.string "passport_number"
    t.string "subject"
    t.string "visa_type"
    t.date "date_of_entry"
    t.date "start_date"
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "city"
    t.string "postcode"
    t.string "application_route"
    t.boolean "state_funded_secondary_school"
    t.boolean "one_year"
    t.string "school_name"
    t.string "school_headteacher_name"
    t.string "school_address_line_1"
    t.string "school_address_line_2"
    t.string "school_city"
    t.string "school_postcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "student_loan"
  end

  create_table "qa_statuses", force: :cascade do |t|
    t.bigint "application_id"
    t.string "status"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id", "status"], name: "index_qa_statuses_on_application_id_and_status", unique: true
    t.index ["application_id"], name: "index_qa_statuses_on_application_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.string "headteacher_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.citext "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "applicants", "schools"
  add_foreign_key "applications", "applicants"
  add_foreign_key "qa_statuses", "applications"

  create_view "duplicate_applications", sql_definition: <<-SQL
      SELECT sub_query.id,
      sub_query.application_date,
      sub_query.urn,
      sub_query.applicant_id,
      sub_query.created_at,
      sub_query.updated_at,
      sub_query.subject,
      sub_query.visa_type,
      sub_query.date_of_entry,
      sub_query.start_date,
      sub_query.application_route,
      sub_query.home_office_csv_downloaded_at,
      sub_query.standing_data_csv_downloaded_at,
      sub_query.payroll_csv_downloaded_at,
      sub_query.duplicate_email,
      sub_query.duplicate_phone,
      sub_query.duplicate_passport
     FROM ( SELECT applications.id,
              applications.application_date,
              applications.urn,
              applications.applicant_id,
              applications.created_at,
              applications.updated_at,
              applications.subject,
              applications.visa_type,
              applications.date_of_entry,
              applications.start_date,
              applications.application_route,
              applications.home_office_csv_downloaded_at,
              applications.standing_data_csv_downloaded_at,
              applications.payroll_csv_downloaded_at,
                  CASE
                      WHEN (count(*) OVER (PARTITION BY applicants.email_address) > 1) THEN applicants.email_address
                      ELSE NULL::text
                  END AS duplicate_email,
                  CASE
                      WHEN (count(*) OVER (PARTITION BY applicants.phone_number) > 1) THEN applicants.phone_number
                      ELSE NULL::text
                  END AS duplicate_phone,
                  CASE
                      WHEN (count(*) OVER (PARTITION BY applicants.passport_number) > 1) THEN applicants.passport_number
                      ELSE NULL::text
                  END AS duplicate_passport
             FROM (applications
               JOIN applicants ON ((applications.applicant_id = applicants.id)))
            WHERE (applications.urn IS NOT NULL)
            GROUP BY applications.id, applicants.email_address, applicants.phone_number, applicants.passport_number) sub_query
    WHERE ((sub_query.duplicate_email IS NOT NULL) OR (sub_query.duplicate_phone IS NOT NULL) OR (sub_query.duplicate_passport IS NOT NULL))
    ORDER BY sub_query.created_at DESC;
  SQL
end
