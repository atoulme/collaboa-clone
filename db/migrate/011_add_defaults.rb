class AddDefaults < ActiveRecord::Migration
  def self.up
    change_column :projects, :closed, :boolean, :default => 0
  end

  def self.down
    change_column :projects, :closed, :boolean
  end
end
