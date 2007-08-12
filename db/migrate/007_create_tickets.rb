class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.integer :milestone_id
      t.integer :component_id
      t.integer :priority_id
      t.integer :release_id
      t.integer :status_id
      t.integer :user_id
      t.integer :project_id
      t.integer :assigned_user_id
      t.string :public_author_text
      t.text :summary
      t.text :content
      t.timestamps 
    end
  end

  def self.down
    drop_table :tickets
  end
end