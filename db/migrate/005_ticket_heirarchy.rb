class TicketHeirarchy < ActiveRecord::Migration
  def self.up
    add_column :tickets, :parent_id, :integer
  end
  
  def self.down
    remove_column :tickets, :parent_id
  end
end
