class AddRepositoriesTable < ActiveRecord::Migration
  def self.up
    create_table "repositories" do |t|
      t.column :project_id, :integer, :null => false
      t.column :name, :string
      t.column :path, :string
      #t.column 
    end
    
    add_column :changes, :repository_id, :integer, :null => false
    add_column :changesets, :repository_id, :integer, :null => false
    
    
  end

  def self.down
    drop_table 'repositories'
    remove_column :changes, :repository_id
    remove_column :changesets, :repository_id
  end
end
