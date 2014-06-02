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

ActiveRecord::Schema.define(:version => 20140215042926) do

  create_table "domain_scores", :force => true do |t|
    t.integer  "observation_read_id"
    t.integer  "quality_score"
    t.integer  "domain_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "domains", :force => true do |t|
    t.integer "number"
    t.string  "description"
  end

  create_table "indicator_scores", :force => true do |t|
    t.integer  "domain_score_id"
    t.integer  "indicator_id"
    t.integer  "alignment_score"
    t.integer  "evidence_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "indicators", :force => true do |t|
    t.string  "code"
    t.string  "description"
    t.integer "domain_id"
  end

  create_table "observation_reads", :force => true do |t|
    t.integer  "observation_group_id"
    t.integer  "employee_id_observer"
    t.integer  "employee_id_learner"
    t.string   "alignment_overall"
    t.integer  "correlation"
    t.integer  "average_difference"
    t.integer  "percent_correct"
    t.integer  "reader_id"
    t.string   "error_pattern_1"
    t.string   "error_pattern_2"
    t.string   "error_pattern_3"
    t.string   "reader_number"
    t.integer  "document_alignment"
    t.integer  "document_quality"
    t.integer  "live_alignment"
    t.integer  "live_quality"
    t.integer  "observation_status"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "readers", :force => true do |t|
    t.integer "employee_number"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "email"
    t.integer "is_reader1a"
    t.integer "is_reader1b"
    t.integer "is_reader2"
  end

end
