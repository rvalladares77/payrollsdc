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

ActiveRecord::Schema[7.1].define(version: 2024_04_13_214225) do
  create_table "csv_imports", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "filename", null: false
    t.integer "report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filename"], name: "index_csv_imports_on_filename", unique: true
    t.index ["report_id"], name: "index_csv_imports_on_report_id", unique: true
  end

  create_table "employees", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "employee_id", limit: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "job_group_id"
    t.index ["employee_id"], name: "index_employees_on_employee_id", unique: true
    t.index ["job_group_id"], name: "index_employees_on_job_group_id"
  end

  create_table "job_groups", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.decimal "hourly_rate", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_job_groups_on_name", unique: true
  end

  create_table "work_logs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.date "work_date", null: false
    t.decimal "hours_worked", precision: 5, scale: 2, null: false
    t.bigint "csv_import_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["csv_import_id"], name: "index_work_logs_on_csv_import_id"
    t.index ["employee_id"], name: "index_work_logs_on_employee_id"
    t.index ["work_date"], name: "index_work_logs_on_work_date"
  end

  add_foreign_key "employees", "job_groups", on_delete: :nullify
  add_foreign_key "work_logs", "csv_imports", on_delete: :nullify
  add_foreign_key "work_logs", "employees", on_delete: :cascade
end
