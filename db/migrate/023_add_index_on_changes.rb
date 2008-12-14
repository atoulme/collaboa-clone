class AddIndexOnChanges < ActiveRecord::Migration
  def self.up
    add_index :changes, :changeset_id
  end

  def self.down
    remove_index :changes, :changeset_id
  end
end
