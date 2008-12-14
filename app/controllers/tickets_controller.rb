class TicketsController < ProjectAreaController
  DEFAULT_FILTER = {"status" => "1"} # Show only open tickets by default
  protect_forms_from_spam :except => [ :delete_change, :destroy ] # turn on form_spam_protection for this controller

  helper :sort
  include SortHelper
  layout 'application', :except => [ :show_editable, :_details_area ]

  verify :method => :post,
    :render => { :text => "bad request: only post allowed", :status => 400 },
    :only => [ :delete_change, :destroy ]

  before_filter :is_admin, :only => [ :delete_change, :destroy ]

  def index
    sort_init('created_at', 'desc')
    sort_update

    logger.info "sort_clause: #{sort_clause}"
    @tickets = Ticket.find_by_filter(params.reverse_merge!(DEFAULT_FILTER), sort_clause).select {|ticket| ticket.project == current_project}
    setup_filter_options
    render :action => 'index'
  end
  
  def show
    sort_init('created_at', 'desc')
    sort_update
 
    @ticket_page = true

    begin
      @ticket = Ticket.find(params[:id], :include => [ :severity, :part, :status, :milestone ])
      params[ "parent" ] = params[:id]
      params["part_id"] = @ticket.part_id
    rescue ActiveRecord::RecordNotFound
      render :text => "Unknown ticket number" and return
    end
    setup_per_project_options

    @change = TicketChange.new
    @change.author = cookies['author']
    
    @change.attributes = params[:change]
    @ticket.attributes = params[:ticket]
    
    if request.post? && (@change.valid? && @ticket.valid?)
      @change.author = params[:change][:author]
      if @ticket.save(params)
        set_author_cookie(@change.author)
        redirect_to :action => 'show', :id => @ticket.id
      end
    end
  end
  
  def attachment
    @change = TicketChange.find(params[:id])
    unless @change.has_attachment?
      redirect_to :action => 'show', :id => @change.ticket_id
    else
      begin
        fullpath = @change.attachment_fsname
        send_file(fullpath, :filename => @change.attachment,:type => @change.content_type, :disposition => 'inline')
      rescue 
        render :text => "Could not find an attachment for this id"
      end
    end
  end

  def new
    @ticket = current_project.tickets.build
    @ticket.author ||= cookies['author']
    setup_per_project_options
  
    if request.post? 
      @ticket = current_project.tickets.create(params[:ticket])
      @ticket.author = params[:ticket][:author]
      @ticket.author_host = request.remote_ip
      @ticket.part_id = params[:part_id].to_i unless params[:part_id].blank?

      set_author_cookie(@ticket.author)

      if @ticket.save
        redirect_to :action => 'show', :id => @ticket.id
      end
    end
  end
  
  def preview
    @ticket = Ticket.new(params[:ticket])
    render :layout => false
  end

  def show_editable
    @ticket = Ticket.find(params[:id], :include => [ :severity, :part, :status, :milestone ])
  end

  def _details_area
    @ticket = Ticket.find(params[:id], :include => [ :severity, :part, :status, :milestone ])
  end

  def delete_change
    c = TicketChange.find(params[:id])
    c.destroy
    redirect_to :back
  end

  def destroy
    t = current_project.tickets.find(params[:id])
    t.destroy
    redirect_to :action => "index", :project => current_project.short_name
  end

  private

    def set_author_cookie(author)
      cookies['author'] = { 'value' => author, 'expires' => 4.weeks.from_now }
    end

    def setup_filter_options
      # FIXME: Some of these only show filter options based on the tickets shown.
      # It's handy because you're not seeing irrelevant milestones, parts, & releases, but 
      # perhaps it prevents someone from doing something they want?
      @milestones = @tickets.collect(&:milestone).compact.uniq
      @severities = Severity.find(:all, :order => 'position DESC')
      @status = Status.find(:all)
      @releases = @tickets.collect(&:release).compact.uniq
      @parts = @tickets.collect(&:part).compact.uniq
      @users = @tickets.collect(&:assigned_user).compact.uniq
    end
    
    def setup_per_project_options
      @milestones = current_project.milestones
      @severities = Severity.find(:all, :order => 'position DESC')
      @releases = current_project.releases
      @status = Status.find(:all)
      @projects = Project.find(:all)    
      @parts = current_project.parts
      @users = current_project.users.reject {|user| user.login == 'Public'}
    end

end
