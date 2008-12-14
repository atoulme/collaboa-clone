class AddMilestonesPermissions < ActiveRecord::Migration
  def self.up
    add_column :users, :view_milestones, :boolean, :default => 1
  end

  def self.down
    remove_column :users, :view_milestones
  end
end
