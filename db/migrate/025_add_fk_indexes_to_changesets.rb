class AddFkIndexesToChangesets < ActiveRecord::Migration
  def self.up
    add_index :changesets, :repository_id
  end

  def self.down
    remove_index :changesets, :repository_id
  end
end
