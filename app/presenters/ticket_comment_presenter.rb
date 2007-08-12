class TicketCommentPresenter
  extend Forwardable
  
  def_delegators :ticket_comment, :author, :author=
  def_delegators :attachment, :uploaded_data, :uploaded_data=
  def_delegators :ticket_comment, :content, :content=
  def_delegators :ticket_comment, :public_author_text=
  
  def_delegators :ticket, :summary, :summary=
  def_delegators :ticket, :status_id, :status_id=
  def_delegators :ticket, :release_id, :release_id=
  def_delegators :ticket, :priority_id, :priority_id=
  def_delegators :ticket, :milestone_id, :milestone_id=
  def_delegators :ticket, :component_id, :component_id=
  def_delegators :ticket, :assigned_user_id, :assigned_user_id=
  def_delegators :ticket, :public_author_text
  
  def initialize(ticket, params = {})
    @ticket, @params = ticket, params
    
    # Set all the values
    params.each_pair do |attribute, value| 
      self.send :"#{attribute}=", value
    end unless params.nil?
  end
  attr_accessor :ticket
  
  def ticket_comment
    @ticket_comment ||= TicketComment.new(:ticket_id => @ticket.id)
  end
  
  def attachment
    @attachment ||= Attachment.new
  end
  
  def save
    # TODO: Should probably do this in a transaction
    self.ticket_comment.save
    self.attachment.ticket_comment = self.ticket_comment
    self.attachment.save    
    self.ticket.comment_for_ticket_changes = ticket_comment
    self.ticket.update_attributes(@params.except(:content, :uploaded_data))
  end
end