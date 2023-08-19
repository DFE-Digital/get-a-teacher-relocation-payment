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

ActiveRecord::Schema[7.0].define(version: 2023_08_16_100957) do
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
    t.date "payment_confirmation_completed_at"
    t.date "rejection_completed_at"
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
    t.index ["applicant_id"], name: "index_applications_on_applicant_id"
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

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.string "headteacher_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.date "service_start_date"
    t.date "service_end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.citext "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "applicants", "schools"
  add_foreign_key "applications", "applicants"
  add_foreign_key "qa_statuses", "applications"

  create_view "duplicate_applications", sql_definition: <<-SQL
      SELECT applications.id,
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
      dup_email.email_address AS duplicate_email
     FROM ((applications
       JOIN applicants ON ((applications.applicant_id = applicants.id)))
       JOIN ( SELECT applicants_1.email_address,
              count(applicants_1.email_address) AS count
             FROM applicants applicants_1
            GROUP BY applicants_1.email_address
           HAVING (count(applicants_1.email_address) > 1)) dup_email ON ((applicants.email_address = dup_email.email_address)))
    WHERE (applications.urn IS NOT NULL)
  UNION
   SELECT applications.id,
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
      dup_phone.phone_number AS duplicate_email
     FROM ((applications
       JOIN applicants ON ((applications.applicant_id = applicants.id)))
       JOIN ( SELECT applicants_1.phone_number,
              count(applicants_1.phone_number) AS count
             FROM applicants applicants_1
            GROUP BY applicants_1.phone_number
           HAVING (count(applicants_1.phone_number) > 1)) dup_phone ON ((applicants.phone_number = dup_phone.phone_number)))
    WHERE (applications.urn IS NOT NULL)
  UNION
   SELECT applications.id,
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
      dup_passport.passport_number AS duplicate_email
     FROM ((applications
       JOIN applicants ON ((applications.applicant_id = applicants.id)))
       JOIN ( SELECT applicants_1.passport_number,
              count(applicants_1.passport_number) AS count
             FROM applicants applicants_1
            GROUP BY applicants_1.passport_number
           HAVING (count(applicants_1.passport_number) > 1)) dup_passport ON ((applicants.passport_number = dup_passport.passport_number)))
    WHERE (applications.urn IS NOT NULL);
  SQL
end
