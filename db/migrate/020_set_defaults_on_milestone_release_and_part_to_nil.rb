class SetDefaultsOnMilestoneReleaseAndPartToNil < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE tickets MODIFY part_id int(11) default null"
    execute "ALTER TABLE tickets MODIFY milestone_id int(11) default null"
  end

  def self.down
    change_column :tickets, :part_id, :integer, :default => 0
    change_column :tickets, :milestone_id, :integer, :default => 0
  end
end
