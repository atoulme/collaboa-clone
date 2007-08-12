class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.integer :user_id
      t.integer :project_id
      t.boolean :view_changesets
      t.boolean :add_changesets
      t.boolean :view_repository
      t.boolean :view_milestones
      t.boolean :add_milestones
      t.boolean :update_milestones
      t.boolean :remove_milestones
      t.boolean :view_tickets
      t.boolean :add_tickets
      t.boolean :update_tickets
      t.boolean :remove_tickets
      t.boolean :alter_tickets
      t.boolean :add_projects
      t.boolean :edit_projects
      t.boolean :remove_projects
      t.timestamps 
    end
  end

  def self.down
    drop_table :permissions
  end
end
