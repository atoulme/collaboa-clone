class FixZeroedFieldsThatShouldBeNull < ActiveRecord::Migration
  def self.up
    execute "update tickets set milestone_id = null where milestone_id = 0"
    execute "update tickets set part_id = null where part_id = 0"
    execute "update tickets set release_id = null where release_id = 0"
  end

  def self.down
  end
end
