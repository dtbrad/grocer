# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170913224524) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "baskets", force: :cascade do |t|
    t.datetime "date"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "user_id"
    t.integer  "total_cents"
    t.boolean  "deleted",               default: false
    t.integer  "google_mail_object_id"
    t.boolean  "fishy_total"
    t.integer  "tax_cents"
    t.integer  "subtotal_cents"
  end

  create_table "failed_gmails", force: :cascade do |t|
    t.jsonb    "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  create_table "failed_mails", force: :cascade do |t|
    t.jsonb    "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "google_mail_objects", force: :cascade do |t|
    t.jsonb    "data"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.datetime "date"
    t.string   "delivered_to"
    t.text     "body_field"
  end

  create_table "hemails", force: :cascade do |t|
    t.date     "my_date"
    t.string   "my_subject"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "email"
    t.string   "old_forwarded"
    t.string   "new_forwarded"
  end

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price"
    t.decimal  "quantity"
    t.integer  "shopping_list_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "basket_id"
    t.integer  "quantity"
    t.integer  "price_cents"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.decimal  "weight"
    t.integer  "total_cents"
    t.integer  "discount_cents", default: 0
    t.boolean  "deleted",        default: false
  end

  create_table "mailgun_messages", force: :cascade do |t|
    t.jsonb    "data"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "user_id"
    t.datetime "date"
    t.text     "body"
    t.text     "body_field"
    t.string   "to_field"
    t.string   "from_field"
    t.string   "x_envelope_from_field"
  end

  create_table "nick_name_requests", force: :cascade do |t|
    t.string   "suggestion"
    t.integer  "product_id"
    t.integer  "user_id"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "nickname"
    t.integer  "real_unit_price_cents"
  end

  create_table "shopping_lists", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "email",                  default: "",    null: false
    t.string   "image"
    t.string   "oauth_token"
    t.string   "oauth_refresh_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "role"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean  "generated_from_email",   default: false
    t.integer  "changed_password",       default: 0
    t.boolean  "fresh",                  default: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
