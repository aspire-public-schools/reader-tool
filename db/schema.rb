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

ActiveRecord::Schema.define(:version => 20140428225330) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "domain_scores", :force => true do |t|
    t.integer  "observation_read_id"
    t.integer  "quality_score"
    t.integer  "domain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "domains", :force => true do |t|
    t.integer "number"
    t.string  "description"
  end

  create_table "evidence_scores", :force => true do |t|
    t.integer  "indicator_score_id"
    t.text     "description"
    t.boolean  "quality"
    t.boolean  "alignment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "indicator_scores", :force => true do |t|
    t.integer  "domain_score_id"
    t.integer  "indicator_id"
    t.integer  "alignment_score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comments"
  end

  create_table "indicators", :force => true do |t|
    t.string   "code",        :limit => 10
    t.string   "description"
    t.integer  "domain_id"
    t.datetime "created_at"
  end

  create_table "observation_reads", :force => true do |t|
    t.integer  "observation_group_id"
    t.integer  "employee_id_observer"
    t.integer  "employee_id_learner"
    t.float    "correlation"
    t.float    "average_difference"
    t.float    "percent_correct"
    t.integer  "reader_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "reader_number",        :limit => 10
    t.integer  "document_quality"
    t.integer  "document_alignment"
    t.integer  "live_quality"
    t.integer  "live_alignment"
    t.integer  "observation_status"
    t.text     "comments"
  end

  create_table "readers", :force => true do |t|
    t.integer "employee_number"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "email"
  end

end
