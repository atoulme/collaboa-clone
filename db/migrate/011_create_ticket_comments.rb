class CreateTicketComments < ActiveRecord::Migration
  def self.up
    create_table :ticket_comments do |t|
      t.integer :author_id
      t.integer :ticket_id
      t.text :content
      t.string :public_author_text
      t.timestamps 
    end
  end

  def self.down
    drop_table :ticket_comments
  end
end
