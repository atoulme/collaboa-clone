class CreateChangesets < ActiveRecord::Migration
  def self.up
    create_table :changesets do |t|
      t.integer :repository_id
      t.integer :revision
      t.string :author
      t.text :log
      t.datetime :revised_at
      t.timestamps 
    end
  end

  def self.down
    drop_table :changesets
  end
end
