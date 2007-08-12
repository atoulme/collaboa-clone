class Ticket < ActiveRecord::Base
  has_many :comments, :class_name => 'TicketComment'
  
  belongs_to :milestone
  belongs_to :author, :class_name => 'User', :foreign_key => "user_id"
  belongs_to :assigned_user, :class_name => 'User'
  belongs_to :project
  belongs_to :status
  belongs_to :priority
  belongs_to :component
  belongs_to :release
  
  validates_presence_of :summary, :content
  validates_presence_of :public_author_text, :if => Proc.new {|ticket| ticket.author == User.public_user}
  
  before_update :create_ticket_changes
  
  include PublicAuthor
  
  def attachments
    self.comments.find(:all, :include => :attachments).map!(&:attachments).flatten!
  end
  
  def to_xml_with_ticket_options
    to_xml_without_ticket_options(:except => [:public_author_text, :priority_id, :milestone_id, :status_id, :component_id, :release_id],
                                  :methods => [:author_text],
                                  :include => [:milestone, :status, :priority, :component, :release])
  end
  alias_method_chain :to_xml, :ticket_options
  
  # Accessor to set the TicketComment that these ticket changes are to be associated with.
  attr_accessor :comment_for_ticket_changes
  def create_ticket_changes
    return true if self.comment_for_ticket_changes.nil?
    
    old_ticket = Ticket.find(self.id)
    new_ticket = self
    
    # Monitor these attributes
    attributes = %w(milestone assigned_user status priority component release summary)
    attributes.each do |attribute|
      values = [old_ticket.send(attribute), new_ticket.send(attribute)].map! do |value|
        if value.blank?
          'Unspecified'
        elsif value.is_a?(TicketAttribute) || value.is_a?(Milestone)
          value.name
        elsif value.is_a?(User)
          value.login
        else
          value
        end
      end
      
      old_value, new_value = values
      logger.info("VALUES: #{old_value} : #{new_value}")
      if old_value != new_value
        TicketChange.create(:attribute_name => attribute, :old_value => old_value, :new_value => new_value, :comment_id => self.comment_for_ticket_changes.id)
      end
    end
    return true
  end
end
