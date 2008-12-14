class MultipleProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |table|
      table.column :name, :string, :limit => 255
      table.column :info, :string
    end

    add_column :tickets, :project_id, :integer
    add_column :milestones, :project_id, :integer
    add_column :parts, :project_id, :integer
    add_column :releases, :project_id, :integer

    execute "insert into projects (id,name,info) values (1,'Default','default')"
    execute "update tickets set project_id = 1"
    execute "update milestones set project_id = 1"
    execute "update parts set project_id = 1"
    execute "update releases set project_id = 1"
  end
  
  def self.down
    drop_table :projects
    remove_column :tickets, :project_id
    remove_column :milestones, :project_id    
    remove_column :parts, :project_id    
    remove_column :releases, :project_id    
  end
end
