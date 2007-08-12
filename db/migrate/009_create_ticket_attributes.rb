class CreateTicketAttributes < ActiveRecord::Migration
  def self.up
    create_table :ticket_attributes do |t|
      t.string :type
      t.integer :project_id
      t.string :name
      t.integer :position
      t.timestamps 
    end
  end

  def self.down
    drop_table :ticket_attributes
  end
end
