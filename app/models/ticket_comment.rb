class TicketComment < ActiveRecord::Base
  has_many :changes, :class_name => 'TicketChange', :foreign_key => 'comment_id'
  has_many :attachments, :foreign_key => 'comment_id'
  belongs_to :ticket
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  
  include PublicAuthor
end
