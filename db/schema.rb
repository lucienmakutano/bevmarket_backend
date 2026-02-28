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

ActiveRecord::Schema[7.1].define(version: 2025_02_02_105748) do

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.boolean "is_partener", default: false, null: false
    t.float "credit", default: 0.0, null: false
    t.integer "establishment_id"
    t.index ["establishment_id"], name: "index_clients_on_establishment_id"
    t.index ["phone_number"], name: "index_clients_on_phone_number", unique: true
  end

  create_table "employees", force: :cascade do |t|
    t.string "role"
    t.integer "establishment_id"
    t.integer "user_id"
    t.integer "sale_point_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["establishment_id"], name: "index_employees_on_establishment_id"
    t.index ["sale_point_id"], name: "index_employees_on_sale_point_id"
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "establishments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "created_by"
    t.index ["created_by"], name: "index_establishments_on_created_by"
  end

  create_table "expenses", force: :cascade do |t|
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.integer "user_id"
    t.text "reason"
    t.integer "establishment_id"
    t.integer "sale_point_id"
    t.index ["establishment_id"], name: "index_expenses_on_establishment_id"
    t.index ["sale_point_id"], name: "index_expenses_on_sale_point_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.integer "bottles_number"
    t.integer "capacity"
    t.string "capacity_unit"
    t.integer "establishment_id"
    t.index ["establishment_id"], name: "index_items_on_establishment_id"
  end

  create_table "sale_items", force: :cascade do |t|
    t.integer "sale_id"
    t.integer "stock_item_id"
    t.decimal "quantity"
    t.decimal "unit_sale_price"
    t.index ["sale_id"], name: "index_sale_items_on_sale_id"
    t.index ["stock_item_id"], name: "index_sale_items_on_stock_item_id"
  end

  create_table "sale_point_stock_items", force: :cascade do |t|
    t.integer "stock_item_id"
    t.integer "sale_point_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sale_point_id"], name: "index_sale_point_stock_items_on_sale_point_id"
    t.index ["stock_item_id"], name: "index_sale_point_stock_items_on_stock_item_id"
  end

  create_table "sale_points", force: :cascade do |t|
    t.integer "establishment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sale_point_type"
    t.index ["establishment_id"], name: "index_sale_points_on_establishment_id"
  end

  create_table "sales", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "user_id"
    t.integer "client_id"
    t.integer "sale_point_id"
    t.integer "establishment_id"
    t.index ["client_id"], name: "index_sales_on_client_id"
    t.index ["establishment_id"], name: "index_sales_on_establishment_id"
    t.index ["sale_point_id"], name: "index_sales_on_sale_point_id"
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "stock_items", force: :cascade do |t|
    t.integer "item_id"
    t.decimal "quantity"
    t.decimal "last_unit_buy_price"
    t.decimal "reduction_sale_price"
    t.decimal "unit_sale_price"
    t.decimal "average_unit_buy_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_stock_items_on_item_id"
  end

  create_table "stock_movements", force: :cascade do |t|
    t.integer "stock_item_id"
    t.decimal "quantity"
    t.string "movement_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "establishment_id"
    t.float "unit_price"
    t.index ["establishment_id"], name: "index_stock_movements_on_establishment_id"
    t.index ["stock_item_id"], name: "index_stock_movements_on_stock_item_id"
  end

  create_table "trucks", force: :cascade do |t|
    t.string "matricule"
    t.string "marque"
    t.integer "sale_point_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sale_point_id"], name: "index_trucks_on_sale_point_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "jti", null: false
    t.boolean "is_employed", default: false
    t.integer "current_establishment_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "warehouses", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.integer "sale_point_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sale_point_id"], name: "index_warehouses_on_sale_point_id"
  end

  add_foreign_key "clients", "establishments"
  add_foreign_key "employees", "establishments"
  add_foreign_key "employees", "sale_points"
  add_foreign_key "employees", "users"
  add_foreign_key "establishments", "users", column: "created_by"
  add_foreign_key "expenses", "establishments"
  add_foreign_key "expenses", "sale_points"
  add_foreign_key "expenses", "users"
  add_foreign_key "items", "establishments"
  add_foreign_key "sale_items", "sales"
  add_foreign_key "sale_items", "stock_items"
  add_foreign_key "sale_point_stock_items", "sale_points"
  add_foreign_key "sale_point_stock_items", "stock_items"
  add_foreign_key "sale_points", "establishments"
  add_foreign_key "sales", "clients"
  add_foreign_key "sales", "establishments"
  add_foreign_key "sales", "sale_points"
  add_foreign_key "sales", "users"
  add_foreign_key "stock_items", "items"
  add_foreign_key "stock_movements", "establishments"
  add_foreign_key "stock_movements", "stock_items"
  add_foreign_key "trucks", "sale_points"
  add_foreign_key "warehouses", "sale_points"
end
