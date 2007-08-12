class CreateTicketChanges < ActiveRecord::Migration
  def self.up
    create_table :ticket_changes do |t|
      t.integer :comment_id
      t.string :attribute_name
      t.string :old_value
      t.string :new_value
      t.timestamps 
    end
  end

  def self.down
    drop_table :ticket_changes
  end
end
