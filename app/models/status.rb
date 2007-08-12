class Status < TicketAttribute
  def self.resolved_statuses
    self.find(:all, :conditions => {:resolved => true})
  end
  
  def self.unresolved_statuses
    self.find(:all, :conditions => {:resolved => false})
  end
  
  def self.resolved_status_ids
    resolved_statuses.map(&:id)
  end
  
  def self.unresolved_status_ids
    resolved_statuses.map(&:id)
  end
end