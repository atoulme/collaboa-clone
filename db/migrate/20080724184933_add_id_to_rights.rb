class AddIdToRights < ActiveRecord::Migration
  def self.up
    drop_table "user_projects"
    create_table "user_projects",  :force => true do |t|
      t.integer "project_id",      :limit => 11
      t.integer "user_id",         :limit => 11
      t.boolean "project_admin"
    end
  end

  def self.down
    drop_table "user_projects"
    create_table "user_projects", :id => false,  :force => true do |t|
      t.integer "project_id",      :limit => 11
      t.integer "user_id",         :limit => 11
      t.boolean "project_admin"
    end
  end
end
