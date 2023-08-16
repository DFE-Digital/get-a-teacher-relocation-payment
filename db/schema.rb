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

ActiveRecord::Schema[7.0].define(version: 2023_08_15_070052) do
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
    t.datetime "home_office_csv_downloaded_at"
    t.datetime "standing_data_csv_downloaded_at"
    t.datetime "payroll_csv_downloaded_at"
    t.index ["applicant_id"], name: "index_applications_on_applicant_id"
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
end
