class TicketsController < ApplicationController
  before_filter :load_project
  before_filter :find_all_ticket_attributes, :only => [:index, :new, :show]
  
  # GET /tickets
  # GET /tickets.xml
  def index
    ensure_user_has_permission_to :view_tickets
    
    @filter_conditions = TicketFilterConditions.new(params)
    @filter_conditions.filter_by :priority, :milestone, :status, :component, :assigned_user
    
    @tickets = Ticket.find(:all, :conditions => @filter_conditions.to_sql_conditions)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tickets }
    end
  end

  # GET /tickets/1
  # GET /tickets/1.xml
  def show
    ensure_user_has_permission_to :view_tickets
    
    @ticket = Ticket.find(params[:id])
    
    @ticket_comment = TicketCommentPresenter.new(@ticket)
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ticket }
    end
  end

  # GET /tickets/new
  # GET /tickets/new.xml
  def new
    ensure_user_has_permission_to :add_tickets
    
    @ticket = Ticket.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ticket }
    end
  end

  # GET /tickets/1/edit
  def edit
    @ticket = Ticket.find(params[:id])
    
    ensure_current_user_can_edit @ticket
  end

  # POST /tickets
  # POST /tickets.xml
  def create
    ensure_user_has_permission_to :add_tickets
    
    @ticket = Ticket.new(params[:ticket])
    @ticket.author = current_user
    @ticket.project = @project
    
    respond_to do |format|
      if @ticket.save
        flash[:notice] = 'Ticket was successfully created.'
        format.html { redirect_to([@project, @ticket]) }
        format.xml  { render :xml => @ticket, :status => :created, :location => @ticket }
      else
        format.html do
          find_all_ticket_attributes
          render :action => "new"
        end
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tickets/1
  # PUT /tickets/1.xml
  def update
    @ticket = Ticket.find(params[:id])
    ensure_current_user_can_edit? @ticket
    
    @ticket_comment = TicketCommentPresenter.new(@ticket, params[:ticket_comment])
    @ticket_comment.author = current_user
        
    respond_to do |format|
      if @ticket_comment.save
        flash[:notice] = 'Ticket was successfully updated.'
        format.html { redirect_to project_ticket_url(@project, @ticket) }
        format.xml  { head :ok }
      else
        format.html do
          find_all_ticket_attributes
          render :action => 'show'
        end
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.xml
  def destroy
    ensure_user_has_permission_to :remove_tickets
    
    @ticket = Ticket.find(params[:id])
    @ticket.destroy

    respond_to do |format|
      format.html { redirect_to(tickets_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  def ensure_current_user_can_edit?(ticket)
    if current_user.tickets.include?(ticket)
      ensure_user_has_permission_to :alter_tickets
    else
      ensure_user_has_permission_to :update_tickets
    end
  end
  
  def find_all_ticket_attributes
    @milestones = @project.milestones
    @priorities = @project.priorities
    @statuses = @project.statuses
    @components = @project.components
    @releases = @project.releases
    @users = @project.users
  end
end
