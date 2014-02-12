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

ActiveRecord::Schema.define(:version => 20140211234500) do

  create_table "observation_reads", :force => true do |t|
    t.integer  "observations_group_id"
    t.integer  "employee_id_observer"
    t.integer  "employee_id_learner"
    t.string   "alignment_overall"
    t.string   "quality_overall"
    t.decimal  "correlation"
    t.decimal  "average_difference"
    t.decimal  "percent_correct"
    t.string   "error_pattern_1"
    t.string   "error_pattern_2"
    t.string   "error_pattern_3"
    t.integer  "reader_number"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "reader_id"
  end

  add_index "observation_reads", ["reader_id"], :name => "index_observations_on_reader_id"

  create_table "readers", :force => true do |t|
    t.integer "employeenumber"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "password_digest"
    t.string  "email"
  end

end
