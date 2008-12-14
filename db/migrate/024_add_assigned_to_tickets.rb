class AddAssignedToTickets < ActiveRecord::Migration
  def self.up
    # This column unintentionally crept into the schema without a migration in [539]
    # so this is out of paranoaia for those migrating up from a previous revision.
    unless  Ticket.column_names.include? 'assigned_user_id'
      add_column :tickets, :assigned_user_id, :integer
    end
  end

  def self.down
    remove_column :tickets, :assigned_user_id
  end
end
