class MoveProjectRepositoryAssociation < ActiveRecord::Migration
  def self.up
    add_column :projects, :repository_id, :integer
    remove_column :repositories, :project_id
  end

  def self.down
    add_column :repositories, :project_id, :integer
    remove_column :projects, :repository_id
  end
end
