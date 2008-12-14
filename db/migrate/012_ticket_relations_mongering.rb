class TicketRelationsMongering < ActiveRecord::Migration
  def self.up
    if Project.find(:all).length == 1
      first_project = Project.find :first
      Ticket.find(:all).each{|t| t.project = first_project; t.save! }
      Part.find(:all).each{|p| p.project = first_project; p.save }
      Milestone.find(:all).each{|m| m.project = first_project; m.save! }
      Release.find(:all).each{|r| r.project = first_project; r.save! }
    end
  end
  
  def self.down
  end
end
