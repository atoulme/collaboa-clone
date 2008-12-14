class ChangeProjectInfoColumnToText < ActiveRecord::Migration
  def self.up
    change_column :projects, :info, :text
  end

  def self.down
    change_column :projects, :info, :string, :limit => 255
  end
end
