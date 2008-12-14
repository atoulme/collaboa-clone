class SearchController < ProjectAreaController

  def index
    @found_items = []
    if params[:q]
      @found_items += Ticket.search(params[:q], @project)
      @found_items += TicketChange.search(params[:q], @project)
      logger.debug params[:changesets]
      @found_items += Changeset.search(params[:q], @project)
    end
  end
  
  end
