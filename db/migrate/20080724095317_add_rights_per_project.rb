class AddRightsPerProject < ActiveRecord::Migration
  
  def self.up
    remove_column :user_projects, :authorized
    remove_column :users, :view_changesets
    remove_column :users, :view_code
    remove_column :users, :view_tickets
    remove_column :users, :create_tickets
    remove_column :users, :view_milestones
    add_column :user_projects, :edit_info, :boolean
    add_column :user_projects, :project_admin, :boolean
    add_column :user_projects, :edit_components, :boolean
    add_column :user_projects, :edit_milestones, :boolean
    add_column :user_projects, :edit_releases, :boolean
  end

  def self.down
    add_column :user_projects, :authorized, :boolean
    add_column :users, :view_changesets, :boolean
    add_column :users, :view_code, :boolean
    add_column :users, :view_tickets, :boolean
    add_column :users, :create_tickets, :boolean
    add_column :users, :view_milestones, :boolean
    remove_column :user_projects, :edit_info
    remove_column :user_projects, :project_admin
    remove_column :user_projects, :edit_components
    remove_column :user_projects, :edit_milestones
    remove_column :user_projects, :edit_releases
  end
end
