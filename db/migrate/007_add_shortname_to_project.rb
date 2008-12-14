class AddShortnameToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :short_name, :text
    add_column :projects, :closed, :boolean
  end

  def self.down
    remove_column :projects, :short_name
    remove_column :projects, :closed
  end
end
