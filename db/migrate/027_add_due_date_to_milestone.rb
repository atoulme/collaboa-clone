class AddDueDateToMilestone < ActiveRecord::Migration
  def self.up
    add_column :milestones, :due_at, :datetime
    remove_column :milestones, :due
  end

  def self.down
    remove_column :milestones, :due_at
    add_column :milestones, :due, :date
  end
end
