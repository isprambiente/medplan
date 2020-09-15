# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_27_232021) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "audits", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "category_id", null: false
    t.integer "status", default: 1, null: false
    t.date "expire", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["category_id", "user_id", "status"], name: "index_audits_on_category_id_and_user_id_and_status", unique: true
    t.index ["category_id"], name: "index_audits_on_category_id"
    t.index ["expire"], name: "index_audits_on_expire"
    t.index ["status"], name: "index_audits_on_status"
    t.index ["user_id"], name: "index_audits_on_user_id"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "code"
    t.string "title", default: "", null: false
    t.integer "months", default: 0, null: false
    t.text "protocol"
    t.boolean "active", default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["active"], name: "index_categories_on_active"
    t.index ["title"], name: "index_categories_on_title", unique: true
  end

  create_table "category_risks", id: :serial, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "risk_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["category_id", "risk_id"], name: "index_category_risks_on_category_id_and_risk_id", unique: true
    t.index ["category_id"], name: "index_category_risks_on_category_id"
    t.index ["risk_id"], name: "index_category_risks_on_risk_id"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.date "date_on", null: false
    t.integer "gender", null: false
    t.text "body"
    t.string "city", null: false
    t.integer "max_users", default: 10, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["date_on", "city", "gender"], name: "index_events_on_date_on_and_city_and_gender", unique: true
    t.index ["date_on"], name: "index_events_on_date_on"
  end

  create_table "histories", id: :serial, force: :cascade do |t|
    t.integer "audit_id"
    t.string "status", default: "", null: false
    t.date "revision_date"
    t.text "body"
    t.string "lab"
    t.integer "city"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "doctor_id"
    t.integer "author_id"
    t.index ["audit_id"], name: "index_histories_on_audit_id"
    t.index ["author_id"], name: "index_histories_on_author_id"
    t.index ["city"], name: "index_histories_on_city"
    t.index ["doctor_id"], name: "index_histories_on_doctor_id"
    t.index ["revision_date"], name: "index_histories_on_revision_date"
    t.index ["status"], name: "index_histories_on_status"
  end

  create_table "meetings", id: :serial, force: :cascade do |t|
    t.integer "audit_id"
    t.integer "event_id"
    t.integer "status", default: 1, null: false
    t.time "start_at", null: false
    t.time "stop_at", null: false
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sended_at"
    t.index ["audit_id"], name: "index_meetings_on_audit_id"
    t.index ["event_id", "audit_id"], name: "index_meetings_on_event_id_and_audit_id", unique: true
    t.index ["event_id"], name: "index_meetings_on_event_id"
    t.index ["start_at"], name: "index_meetings_on_start_at"
    t.index ["status"], name: "index_meetings_on_status"
  end

  create_table "risks", id: :serial, force: :cascade do |t|
    t.string "code"
    t.string "title", default: "", null: false
    t.boolean "printed", default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["title"], name: "index_risks_on_title", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "locked_at"
    t.string "username"
    t.citext "label", default: ""
    t.integer "city", null: false
    t.text "body", default: ""
    t.boolean "secretary", default: false
    t.boolean "doctor", default: false
    t.boolean "admin", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "deleted", default: false
    t.string "cf", default: "", null: false
    t.string "tel", default: ""
    t.integer "postazione", default: 1, null: false
    t.jsonb "metadata", default: {}, null: false
    t.index ["cf"], name: "index_users_on_cf", unique: true
    t.index ["city"], name: "index_users_on_city"
    t.index ["metadata"], name: "index_users_on_metadata", using: :gin
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "histories", "users", column: "author_id", on_delete: :restrict
  add_foreign_key "histories", "users", column: "doctor_id", on_delete: :restrict
end
