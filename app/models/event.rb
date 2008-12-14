class Event < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :ticket_change
  belongs_to :changeset
  belongs_to :project
  
  serialize :link
  
  validates_presence_of :title
  
end
