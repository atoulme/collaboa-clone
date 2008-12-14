class AddNnRelationsTables < ActiveRecord::Migration
  def self.up
    create_table "projects_tags" do |t|
      t.integer "project_id"
      t.integer "tag_id"
    end
    create_table "projects_categories" do |t|
      t.integer "project_id"
      t.integer "tag_id"
    end
  end

  def self.down
    drop_table "projects_tags"
    drop_table "projects_categories"
  end
end
