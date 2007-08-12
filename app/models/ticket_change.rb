class TicketChange < ActiveRecord::Base
  belongs_to :ticket_comment, :foreign_key => 'comment_id'
end
