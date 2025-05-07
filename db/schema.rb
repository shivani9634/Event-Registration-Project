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

ActiveRecord::Schema[8.0].define(version: 2025_04_29_180305) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discount_codes", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "discount_code", null: false
    t.string "discount_type", null: false
    t.decimal "discount_value", precision: 8, scale: 2, null: false
    t.date "valid_from", null: false
    t.date "valid_until", null: false
    t.integer "max_uses", null: false
    t.integer "current_uses", null: false
    t.boolean "is_active", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_discount_codes_on_event_id"
    t.index ["user_id"], name: "index_discount_codes_on_user_id"
  end

  create_table "event_registrations", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "user_id", null: false
    t.integer "discount_code_id"
    t.decimal "final_fee", precision: 8, scale: 2, null: false
    t.datetime "registration_date", null: false
    t.string "status", null: false
    t.integer "no_of_people", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discount_code_id"], name: "index_event_registrations_on_discount_code_id"
    t.index ["event_id"], name: "index_event_registrations_on_event_id"
    t.index ["user_id"], name: "index_event_registrations_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "organizer_id", null: false
    t.string "name", null: false
    t.text "description", null: false
    t.string "venue", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "max_participants", null: false
    t.boolean "id_proof_required", null: false
    t.decimal "early_bird_cost", precision: 8, scale: 2, null: false
    t.datetime "early_bird_end_date", null: false
    t.string "status", null: false
    t.decimal "base_cost", precision: 8, scale: 2, null: false
    t.integer "current_participants", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_events_on_category_id"
    t.index ["organizer_id"], name: "index_events_on_organizer_id"
  end

  create_table "location_details", force: :cascade do |t|
    t.text "address", null: false
    t.string "location_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "event_registration_id", null: false
    t.decimal "amount", precision: 8, scale: 2, null: false
    t.string "payment_mode", null: false
    t.date "payment_date", null: false
    t.string "status", null: false
    t.string "transaction_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_registration_id"], name: "index_payments_on_event_registration_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "role_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "surname", null: false
    t.string "password_digest", null: false
    t.bigint "phone_number", null: false
    t.string "email_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["surname"], name: "index_users_on_surname", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "discount_codes", "events"
  add_foreign_key "discount_codes", "users"
  add_foreign_key "event_registrations", "discount_codes", on_delete: :cascade
  add_foreign_key "event_registrations", "events", on_delete: :cascade
  add_foreign_key "event_registrations", "users"
  add_foreign_key "events", "categories"
  add_foreign_key "events", "users", column: "organizer_id"
  add_foreign_key "payments", "event_registrations"
  add_foreign_key "users", "roles"
end
