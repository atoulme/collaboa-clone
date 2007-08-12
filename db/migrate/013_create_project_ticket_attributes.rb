class CreateProjectTicketAttributes < ActiveRecord::Migration
  def self.up
    create_table :project_ticket_attributes do |t|
      t.integer :project_id
      t.integer :ticket_attribute_id
      t.timestamps 
    end
    
    remove_column :ticket_attributes, :project_id
  end

  def self.down
    drop_table :project_ticket_attributes
    add_column :ticket_attributes, :project_id, :integer
  end
end
