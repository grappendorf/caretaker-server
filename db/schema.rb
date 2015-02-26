# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150225235510) do

  create_table "buildings", force: true do |t|
    t.string "name"
    t.string "description"
  end

  add_index "buildings", ["name"], name: "index_buildings_on_name"

  create_table "camera_devices", force: true do |t|
    t.string  "host"
    t.integer "port"
    t.string  "user"
    t.string  "password"
    t.string  "refresh_interval"
  end

  create_table "dashboards", force: true do |t|
    t.string  "name"
    t.boolean "default"
    t.integer "user_id"
  end

  create_table "device_scripts", force: true do |t|
    t.string  "name"
    t.string  "description"
    t.text    "script"
    t.boolean "enabled"
  end

  create_table "device_widgets", force: true do |t|
    t.integer "device_id"
    t.string  "device_type"
  end

  create_table "devices", force: true do |t|
    t.integer "as_device_id"
    t.string  "as_device_type"
    t.string  "name"
    t.string  "address"
    t.string  "description"
    t.string  "guid"
  end

  add_index "devices", ["as_device_id", "as_device_type"], name: "index_devices_on_as_device_id_and_as_device_type"
  add_index "devices", ["name"], name: "index_devices_on_name", unique: true

  create_table "dimmer_devices", force: true do |t|
  end

  create_table "dimmer_rgb_devices", force: true do |t|
  end

  create_table "easyvr_devices", force: true do |t|
    t.integer "num_buttons"
    t.integer "buttons_per_row"
  end

  create_table "floors", force: true do |t|
    t.string  "name"
    t.string  "description"
    t.integer "building_id"
  end

  add_index "floors", ["name"], name: "index_floors_on_name"

  create_table "ip_camera_devices", force: true do |t|
    t.string  "host"
    t.integer "port"
    t.string  "user"
    t.string  "password"
    t.string  "refresh_interval"
  end

  create_table "reflow_oven_devices", force: true do |t|
  end

  create_table "remote_control_devices", force: true do |t|
    t.integer "num_buttons"
    t.integer "buttons_per_row"
  end

  create_table "robot_devices", force: true do |t|
  end

  create_table "roles", force: true do |t|
    t.string  "name"
    t.integer "resource_id"
    t.string  "resource_type"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "rooms", force: true do |t|
    t.string  "number"
    t.string  "description"
    t.integer "floor_id"
  end

  add_index "rooms", ["number"], name: "index_rooms_on_number"

  create_table "switch_devices", force: true do |t|
    t.integer "num_switches"
    t.integer "switches_per_row"
  end

  create_table "users", force: true do |t|
    t.string  "name"
    t.string  "email",                  default: ""
    t.string  "encrypted_password",     default: ""
    t.string  "reset_password_token"
    t.time    "reset_password_sent_at"
    t.time    "remember_created_at"
    t.integer "sign_in_count",          default: 0
    t.time    "current_sign_in_at"
    t.time    "last_sign_in_at"
    t.string  "current_sign_in_ip"
    t.string  "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email"

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

  create_table "weather_widgets", force: true do |t|
  end

  create_table "widgets", force: true do |t|
    t.integer "as_widget_id"
    t.string  "as_widget_type"
    t.integer "width",          default: 1
    t.integer "height",         default: 1
    t.string  "title"
    t.integer "dashboard_id"
    t.integer "position"
  end

  add_index "widgets", ["as_widget_id", "as_widget_type"], name: "index_widgets_on_as_widget_id_and_as_widget_type"

end
