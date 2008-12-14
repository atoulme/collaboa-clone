class RssController < ApplicationController
  before_filter :set_xml_header, :except => [ :index ]
  before_filter :current_project
  
  def index
    render :layout => 'application'
  end
  
  def all
    @rss_title = FORGE_NAME
    @items = []
    
  	get_tickets
  	get_changesets
  	tail
	
  	render :action => 'rss'
  end
  
  def tickets
  	@rss_title = FORGE_NAME + ' - All Tickets'
  	@items = []
  	
  	get_tickets
  	tail
	
  	render :action => 'rss'
  end
  
  def changesets
  	@rss_title = FORGE_NAME + ' - Changesets'
  	@items = []		
  	
  	get_changesets
  	tail
	
  	render :action => 'rss'
  end  
  
  private
    def tail
  		#sort  
  		@items.sort! { |a,b| b[:date]<=>a[:date] }		
  		#..now get 10 most recent items regardless of type
  		@items.slice!(10 .. @items.size) if @items.size>10	
  	end
	
  	def get_tickets
  		Ticket.find(:all, :order => 'created_at DESC', :limit => 10).each do |ticket|
  		  @items << {:title => "Ticket ##{ticket.id} created: " + ticket.summary,
  					:content => ticket.content,
  					:author => ticket.author,
  					:date => ticket.created_at,
  		  		:link => (url_for :controller=>'tickets', :action=>'show', :id=>ticket.id),
  		  		:project => ticket.project }
  		end
	
  		TicketChange.find(:all, :order => 'created_at DESC', :limit => 10).each do |change|
  		  changes = ''
  		  change.each_log {|logitem| changes << '<ul>' + format_changes(logitem) + '</ul>' }
	
  		  @items << {:title => "Ticket ##{change.ticket_id} modified by #{change.author}",
  					:content => change.comment,
  					:changes => changes,
  					:author => change.author,
  					:date => change.created_at,
  					:link => (url_for :controller=>'tickets', :action=>'show', :id=>change.ticket_id),
  					:project => change.ticket.project }					
  		end   	
  	end
  
  	def get_changesets
  		Changeset.find(:all, :order => 'created_at DESC', :limit => 15).each do |changeset|
  		  @items << {:title => "Changeset [#{changeset.revision}]: #{changeset.log}",
  					:content => changeset.log,
  					:author => changeset.author,
  					:date => changeset.revised_at,
  					:link => (url_for :controller=>'repository', :action=>'changesets', :id=>changeset.revision) }
  		end	
  	end

    def format_changes(change_arr)
      "<li>#{change_arr.format_changes_simple}</li>"
    end
    
    def set_xml_header
      headers["Content-Type"] = "text/xml; charset=utf-8"
      params[:format] = 'rss'
    end
    
end
