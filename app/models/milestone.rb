class Milestone < ActiveRecord::Base
  has_many :tickets
  
  def open_tickets
    resolved_tickets_statuses = Status.unresolved_status_ids
    self.tickets.find(:all, :conditions => {:status_id => resolved_tickets_statuses})
  end
  
  def closed_tickets
    resolved_tickets_statuses = Status.resolved_status_ids
    self.tickets.find(:all, :conditions => {:status_id => resolved_tickets_statuses})
  end
  
  def completed_tickets_percentage
    return 0 if self.tickets.empty?
    (self.closed_tickets.size.to_f / self.tickets.count.to_f * 100).to_i
  end
end
