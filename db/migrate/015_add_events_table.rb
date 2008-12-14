class AddEventsTable < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.column :project_id,     :integer, :null => false
      t.column :title,          :string, :null => false
      t.column :content,        :text, :null => true
      t.column :created_at,     :datetime
      t.column :link,              :string
      t.column :ticket_id,         :integer
      t.column :ticket_change_id,  :integer
      t.column :changeset_id,      :integer
    end
  end

  def self.down
    drop_table :events
  end
end
