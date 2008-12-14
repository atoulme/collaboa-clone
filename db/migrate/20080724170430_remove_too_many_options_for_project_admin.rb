class RemoveTooManyOptionsForProjectAdmin < ActiveRecord::Migration
  def self.up
    remove_column :user_projects, :edit_info
    remove_column :user_projects, :edit_components
    remove_column :user_projects, :edit_milestones
    remove_column :user_projects, :edit_releases
  end

  def self.down
    add_column :user_projects, :edit_info, :boolean
    add_column :user_projects, :edit_components, :boolean
    add_column :user_projects, :edit_milestones, :boolean
    add_column :user_projects, :edit_releases, :boolean
  end
end
