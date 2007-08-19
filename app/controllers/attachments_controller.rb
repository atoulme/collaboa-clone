class AttachmentsController < ApplicationController
  before_filter :load_project
  
  # GET /attachments/1
  # GET /attachments/1.xml
  def show
    @ticket = @project.tickets.find(params[:ticket_id])
    @attachment = @ticket.attachments.select {|attachment| attachment.id == params[:id].to_i}.first

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @attachment }
    end
  end
end
