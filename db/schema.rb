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

ActiveRecord::Schema.define(:version => 20150408235157) do

  create_table "all_evidence", :id => false, :force => true do |t|
    t.integer  "observation_group_id"
    t.string   "employee_id_observer"
    t.string   "observer_name"
    t.string   "employee_id_learner"
    t.integer  "evidence_id"
    t.text     "evidence"
    t.string   "indicator_code"
    t.integer  "row_id"
    t.datetime "created_at"
  end

  add_index "all_evidence", ["observation_group_id"], :name => "index_all_evidence_on_observation_group_id"

  create_table "domain_scores", :force => true do |t|
    t.integer  "observation_read_id"
    t.integer  "quality_score"
    t.integer  "domain_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "domain_scores", ["domain_id"], :name => "index_domain_scores_on_domain_id"
  add_index "domain_scores", ["observation_read_id"], :name => "index_domain_scores_on_observation_read_id"

  create_table "domains", :force => true do |t|
    t.integer "number"
    t.string  "description"
  end

  create_table "evidence_scores", :force => true do |t|
    t.integer  "indicator_score_id"
    t.integer  "evidence_id"
    t.text     "description"
    t.text     "comments"
    t.float    "quality"
    t.float    "alignment"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "evidence_scores", ["indicator_score_id"], :name => "index_evidence_scores_on_indicator_score_id"

  create_table "indicator_scores", :force => true do |t|
    t.integer  "domain_score_id"
    t.integer  "indicator_id"
    t.integer  "alignment_score"
    t.integer  "evidence_id"
    t.text     "comments"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "indicator_scores", ["domain_score_id", "indicator_id"], :name => "index_indicator_scores_on_domain_score_id_and_indicator_id"
  add_index "indicator_scores", ["domain_score_id"], :name => "index_indicator_scores_on_domain_score_id"
  add_index "indicator_scores", ["indicator_id"], :name => "index_indicator_scores_on_indicator_id"

  create_table "indicators", :force => true do |t|
    t.string  "code"
    t.string  "description"
    t.integer "domain_id"
  end

  add_index "indicators", ["domain_id"], :name => "index_indicators_on_domain_id"

  create_table "observation_reads", :force => true do |t|
    t.integer  "observation_group_id"
    t.string   "employee_id_observer"
    t.string   "employee_id_learner"
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
    t.boolean  "flagged"
    t.text     "comments"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "observation_reads", ["observation_group_id"], :name => "index_observation_reads_on_observation_group_id"
  add_index "observation_reads", ["reader_id"], :name => "index_observation_reads_on_reader_id"
  add_index "observation_reads", ["reader_number"], :name => "index_observation_reads_on_reader_number"

  create_table "readers", :force => true do |t|
    t.integer  "employee_number"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.boolean  "is_reader1a"
    t.boolean  "is_reader1b"
    t.boolean  "is_reader2"
    t.string   "password_digest"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  add_index "readers", ["employee_number"], :name => "index_readers_on_employee_number"
  add_index "readers", ["is_reader1a"], :name => "index_readers_on_is_reader1a"
  add_index "readers", ["is_reader1b"], :name => "index_readers_on_is_reader1b"
  add_index "readers", ["is_reader2"], :name => "index_readers_on_is_reader2"

end
