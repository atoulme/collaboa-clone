class AddFkIndexesToChanges < ActiveRecord::Migration
  def self.up
    add_index :changes, :repository_id
  end

  def self.down
    remove_index :changes, :repository_id
  end
end
