class ProjectTicketAttribute < ActiveRecord::Base
  belongs_to :project
  belongs_to :ticket_attribute
end
