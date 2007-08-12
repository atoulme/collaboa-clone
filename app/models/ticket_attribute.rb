class TicketAttribute < ActiveRecord::Base
  has_many :project_ticket_attributes
  has_many :projects, :through => :project_ticket_attributes
end
