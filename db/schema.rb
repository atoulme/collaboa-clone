# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080725131635) do

  create_table "categories", :force => true do |t|
    t.string  "name"
    t.text    "description"
    t.integer "parent",      :limit => 11
  end

  create_table "changes", :force => true do |t|
    t.integer "changeset_id",  :limit => 11
    t.integer "revision",      :limit => 11, :default => 0,  :null => false
    t.string  "name",          :limit => 2,  :default => "", :null => false
    t.text    "path",                                        :null => false
    t.text    "from_path"
    t.integer "from_revision", :limit => 11
    t.integer "repository_id", :limit => 11,                 :null => false
  end

  add_index "changes", ["changeset_id"], :name => "changes_changeset_id_index"
  add_index "changes", ["repository_id"], :name => "changes_repository_id_index"

  create_table "changesets", :force => true do |t|
    t.integer  "revision",      :limit => 11
    t.string   "author",        :limit => 50
    t.text     "log"
    t.datetime "created_at"
    t.datetime "revised_at"
    t.integer  "repository_id", :limit => 11, :null => false
  end

  add_index "changesets", ["repository_id"], :name => "changesets_repository_id_index"

  create_table "events", :force => true do |t|
    t.integer  "project_id",       :limit => 11,                 :null => false
    t.string   "title",                          :default => "", :null => false
    t.text     "content"
    t.datetime "created_at"
    t.string   "link"
    t.integer  "ticket_id",        :limit => 11
    t.integer  "ticket_change_id", :limit => 11
    t.integer  "changeset_id",     :limit => 11
  end

  create_table "milestones", :force => true do |t|
    t.string   "name",       :limit => 75
    t.text     "info"
    t.boolean  "completed",                :default => false
    t.datetime "created_at"
    t.integer  "project_id", :limit => 11
    t.integer  "length",     :limit => 11
    t.datetime "due_at"
  end

  create_table "parts", :force => true do |t|
    t.string  "name",       :limit => 50
    t.integer "project_id", :limit => 11
    t.integer "parent_id",  :limit => 11
  end

  create_table "projects", :force => true do |t|
    t.string  "name"
    t.text    "info"
    t.text    "short_name"
    t.boolean "closed",                      :default => false
    t.integer "repository_id", :limit => 11
    t.text    "root_path",                                      :null => false
  end

  create_table "projects_categories", :force => true do |t|
    t.integer "project_id", :limit => 11
    t.integer "tag_id",     :limit => 11
  end

  create_table "projects_tags", :force => true do |t|
    t.integer "project_id", :limit => 11
    t.integer "tag_id",     :limit => 11
  end

  create_table "releases", :force => true do |t|
    t.string  "name",         :limit => 25
    t.integer "project_id",   :limit => 11
    t.string  "download_url"
    t.text    "info"
  end

  create_table "repositories", :force => true do |t|
    t.string "name"
    t.string "path"
  end

  create_table "sessions", :force => true do |t|
    t.string "sessid", :limit => 32
    t.text   "data"
  end

  create_table "severities", :force => true do |t|
    t.integer "position", :limit => 11
    t.string  "name",     :limit => 50
  end

  create_table "status", :force => true do |t|
    t.string "name", :limit => 25
  end

  create_table "tags", :force => true do |t|
    t.string "name"
    t.text   "description"
  end

  create_table "ticket_changes", :force => true do |t|
    t.integer  "ticket_id",         :limit => 11
    t.string   "author",            :limit => 75
    t.text     "comment"
    t.datetime "created_at"
    t.text     "log"
    t.string   "attachment"
    t.string   "content_type",      :limit => 100
    t.string   "attachment_fsname"
  end

  create_table "tickets", :force => true do |t|
    t.integer  "milestone_id",       :limit => 11
    t.integer  "part_id",            :limit => 11
    t.integer  "severity_id",        :limit => 11,  :default => 0, :null => false
    t.integer  "release_id",         :limit => 11
    t.integer  "status_id",          :limit => 11,  :default => 1, :null => false
    t.string   "author",             :limit => 75
    t.string   "summary"
    t.text     "content"
    t.string   "author_host",        :limit => 100
    t.datetime "created_at"
    t.integer  "project_id",         :limit => 11
    t.integer  "parent_id",          :limit => 11
    t.boolean  "time_and_materials"
    t.integer  "estimate",           :limit => 11
    t.integer  "assigned_user_id",   :limit => 11
  end

  create_table "user_projects", :force => true do |t|
    t.integer "project_id",    :limit => 11
    t.integer "user_id",       :limit => 11
    t.boolean "project_admin"
  end

  create_table "user_rates", :force => true do |t|
    t.integer  "project_id",  :limit => 11, :null => false
    t.integer  "user_id",     :limit => 11, :null => false
    t.datetime "start_date"
    t.datetime "end_date"
    t.float    "rate"
    t.string   "description"
  end

  create_table "users", :force => true do |t|
    t.string   "login",      :limit => 80
    t.datetime "created_at"
    t.boolean  "admin",                    :default => false
  end

  create_table "work_entries", :force => true do |t|
    t.integer  "ticket_id",       :limit => 11
    t.integer  "project_id",      :limit => 11
    t.integer  "user_id",         :limit => 11
    t.date     "bill_date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "description"
    t.integer  "revision",        :limit => 11
    t.text     "client_desc"
    t.float    "rate_multiplier"
    t.integer  "credit_id",       :limit => 11
    t.integer  "user_rate_id",    :limit => 11
  end

end
