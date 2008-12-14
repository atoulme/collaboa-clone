class AddUserProjectsMapping < ActiveRecord::Migration
  def self.up
    create_table :user_projects, :id => false  do |table|
      table.column :project_id, :integer
      table.column :user_id, :integer
      table.column :authorized, :boolean
    end
  end

  def self.down
    drop_table :user_projects
  end
end
