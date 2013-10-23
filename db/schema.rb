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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131022182803) do

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "members", :force => true do |t|
    t.string   "username",            :default => "", :null => false
    t.string   "encrypted_password",  :default => "", :null => false
    t.datetime "remember_created_at"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "members", ["username"], :name => "index_members_on_username", :unique => true

  create_table "replies", :force => true do |t|
    t.integer  "author_id"
    t.integer  "ticket_id"
    t.text     "response"
    t.integer  "new_assignee_id"
    t.integer  "new_status_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "replies", ["author_id"], :name => "index_replies_on_author_id"
  add_index "replies", ["ticket_id"], :name => "index_replies_on_ticket_id"

  create_table "tickets", :force => true do |t|
    t.string   "reference"
    t.string   "client_name"
    t.string   "client_email"
    t.integer  "department_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "status_id",     :default => 0, :null => false
    t.integer  "assignee_id"
  end

  add_index "tickets", ["assignee_id"], :name => "index_tickets_on_assignee_id"
  add_index "tickets", ["department_id"], :name => "index_tickets_on_department_id"
  add_index "tickets", ["reference"], :name => "index_tickets_on_reference", :unique => true
  add_index "tickets", ["status_id"], :name => "index_tickets_on_status_id"

end
