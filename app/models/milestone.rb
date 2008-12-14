class Milestone < ActiveRecord::Base
  has_many :tickets
  belongs_to :project
  
  def open_tickets
    self.tickets.count(:conditions => "status_id <= 1") # using '<=' just in case
  end
  
  def closed_tickets
    self.tickets.count(:conditions => "status_id > 1")
  end
  
  def total_tickets
    self.closed_tickets + self.open_tickets
  end
  
  def completed_tickets_percent
    return 0 if self.tickets.empty?
    (self.closed_tickets.to_f / self.total_tickets.to_f * 100).to_i
  end
end
