class AddProjectPathPrefix < ActiveRecord::Migration
  def self.up
    add_column :projects, :root_path, :text, :default => "", :null => false 
    # Called "project root" at http://svnbook.red-bean.com/en/1.1/ch05s04.html so I thought "root path" is an appropriate name for the root of the project within a repository
  end

  def self.down
    remove_column :projects, :root_path
  end
end
