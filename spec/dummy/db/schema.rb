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

ActiveRecord::Schema.define(:version => 20130722162331) do

  create_table "activity_engine_activities", :force => true do |t|
    t.integer  "user_id"
    t.string   "subject_type",  :null => false
    t.string   "subject_id",    :null => false
    t.string   "activity_type", :null => false
    t.text     "message"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "activity_engine_activities", ["user_id"], :name => "index_activity_engine_activities_on_user_id"

end
