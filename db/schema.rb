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

ActiveRecord::Schema.define(version: 2020_03_28_010555) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "servicers", force: :cascade do |t|
    t.string "name"
    t.bigint "source_type_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "user_id", "source_type_id"], name: "index_servicers_on_name_and_user_id_and_source_type_id", unique: true
    t.index ["source_type_id"], name: "index_servicers_on_source_type_id"
    t.index ["user_id"], name: "index_servicers_on_user_id"
  end

  create_table "source_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.index ["name", "user_id"], name: "index_source_types_on_name_and_user_id", unique: true
    t.index ["user_id"], name: "index_source_types_on_user_id"
  end

  create_table "sources", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.bigint "servicer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "user_id", "servicer_id"], name: "index_sources_on_name_and_user_id_and_servicer_id", unique: true
    t.index ["servicer_id"], name: "index_sources_on_servicer_id"
    t.index ["user_id"], name: "index_sources_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "source_id", null: false
    t.string "name"
    t.date "date"
    t.integer "transaction_type", null: false
    t.decimal "amount"
    t.string "transaction_category"
    t.string "transaction_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["source_id"], name: "index_transactions_on_source_id"
    t.index ["transaction_id"], name: "index_transactions_on_transaction_id", unique: true
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "servicers", "source_types"
  add_foreign_key "servicers", "users"
  add_foreign_key "source_types", "users"
  add_foreign_key "sources", "servicers"
  add_foreign_key "sources", "users"
  add_foreign_key "transactions", "sources"
  add_foreign_key "transactions", "users"
end
