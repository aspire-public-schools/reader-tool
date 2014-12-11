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

ActiveRecord::Schema.define(:version => 20140215042950) do

  create_table "all_evidence", :id => false, :force => true do |t|
    t.integer "observation_group_id"
    t.string  "employee_id_observer", :limit => 10
    t.string  "observer_name",        :limit => 100
    t.string  "employee_id_learner",  :limit => 10
    t.integer "evidence_id"
    t.text    "evidence"
    t.string  "indicator_code",       :limit => 10
  end

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
    t.integer  "evidence_id"
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
    t.float    "correlation"
    t.float    "average_difference"
    t.float    "percent_correct"
    t.integer  "reader_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at"
    t.string   "reader_number",        :limit => 10
    t.integer  "document_quality"
    t.integer  "document_alignment"
    t.integer  "live_quality"
    t.integer  "live_alignment"
    t.integer  "observation_status"
    t.text     "comments"
    t.boolean  "flags"
    t.string   "employee_id_observer", :limit => 10
    t.string   "employee_id_learner",  :limit => 10
  end

  create_table "readers", :force => true do |t|
    t.integer "employee_number"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "email"
    t.string  "is_reader1a",     :limit => 1
    t.string  "is_reader1b",     :limit => 1
    t.string  "is_reader2",      :limit => 1
  end

end
