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

ActiveRecord::Schema[7.1].define(version: 2023_11_05_170903) do
  create_table "active_sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.string "remember_token", null: false
    t.index ["remember_token"], name: "index_active_sessions_on_remember_token", unique: true
    t.index ["user_id"], name: "index_active_sessions_on_user_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "resource"
    t.string "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action", "resource"], name: "index_permissions_on_action_and_resource", unique: true
  end

  create_table "permissions_users", id: false, force: :cascade do |t|
    t.integer "permission_id", null: false
    t.integer "user_id", null: false
    t.index ["permission_id"], name: "index_permissions_users_on_permission_id"
    t.index ["user_id"], name: "index_permissions_users_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.string "image_source"
    t.integer "user_id", null: false
    t.string "favicon_source"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "confirmed_at"
    t.string "password_digest"
    t.string "email"
    t.string "unconfirmed_email"
  end

  add_foreign_key "active_sessions", "users", on_delete: :cascade
  add_foreign_key "posts", "users"
end
