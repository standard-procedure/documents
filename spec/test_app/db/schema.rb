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

ActiveRecord::Schema[8.0].define(version: 2025_07_21_135938) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "documents_elements", force: :cascade do |t|
    t.string "type"
    t.string "container_type"
    t.integer "container_id"
    t.integer "position", null: false
    t.text "description"
    t.text "html"
    t.string "url"
    t.integer "columns", default: 0, null: false
    t.integer "section_type", default: 0, null: false
    t.integer "display_type", default: 0, null: false
    t.integer "form_submission_status", default: 0, null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["container_type", "container_id", "position"], name: "idx_on_container_type_container_id_position_f53b0cf137", unique: true
    t.index ["container_type", "container_id"], name: "index_documents_elements_on_container"
  end

  create_table "documents_field_values", force: :cascade do |t|
    t.integer "section_id"
    t.integer "position", null: false
    t.text "data"
    t.string "name", null: false
    t.string "description", null: false
    t.string "type"
    t.boolean "required", default: false, null: false
    t.boolean "allow_comments", default: false, null: false
    t.boolean "allow_attachments", default: false, null: false
    t.boolean "allow_tasks", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id", "position"], name: "index_documents_field_values_on_section_id_and_position", unique: true
    t.index ["section_id"], name: "index_documents_field_values_on_section_id"
  end

  create_table "documents_form_sections", force: :cascade do |t|
    t.integer "form_id"
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["form_id", "position"], name: "index_documents_form_sections_on_form_id_and_position", unique: true
    t.index ["form_id"], name: "index_documents_form_sections_on_form_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "documents_field_values", "documents_form_sections", column: "section_id"
  add_foreign_key "documents_form_sections", "documents_elements", column: "form_id"
end
