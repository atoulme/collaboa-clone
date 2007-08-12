class CreateMilestones < ActiveRecord::Migration
  def self.up
    create_table :milestones do |t|
      t.integer :project_id
      t.string :name
      t.text :info
      t.datetime :completed_at
      t.timestamps 
    end
  end

  def self.down
    drop_table :milestones
  end
end
