class Attachment < ActiveRecord::Base
  belongs_to :ticket_comment, :foreign_key => 'comment_id'
  
  has_attachment :storage => :file_system, :max_size => 1.megabyte
  validates_as_attachment
end
