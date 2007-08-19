require File.dirname(__FILE__) + '/../spec_helper'

describe AttachmentsController, "#route_for" do
  
  it "should map { :controller => 'attachments', :action => 'show', :id => 1, :project_id => 1, :ticket_id => 1 } to /projects/1/tickets/1/attachments/1" do
    route_for(:controller => "attachments", :action => "show", :id => 1, :project_id => 1, :ticket_id => 1).should == "/projects/1/tickets/1/attachments/1"
  end
  
end

describe AttachmentsController, "handling GET /tickets/1/attachments/1" do

  before do
    @attachment = mock_model(Attachment)
    @attachments = [@attachment]
    @attachments.stub!(:select).and_return([@attachment])
    
    @ticket = mock_model(Ticket, :attachments => @attachments)
    @tickets = [@ticket]
    @tickets.stub!(:find).and_return(@ticket)
    
    @project = mock_model(Project, :tickets => @tickets)
    Project.stub!(:find).and_return(@project)
  end
  
  def do_get
    get :show, :id => '1', :ticket_id => '1', :project_id => '1'
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render show template" do
    do_get
    response.should render_template('show')
  end
  
  it "should find the requested attachment" do
    @attachments.should_receive(:select).and_return([@attachment])
    do_get
  end
  
  it "should assign the found attachment for the view" do
    do_get
    assigns[:attachment].should equal(@attachment)
  end
end

describe AttachmentsController, "handling GET /attachments/1.xml" do

  before do    
    @attachment = mock_model(Attachment, :to_xml => 'XML')
    @attachments = [@attachment]
    @attachments.stub!(:select).and_return([@attachment])
    
    @ticket = mock_model(Ticket, :attachments => @attachments)
    @tickets = [@ticket]
    @tickets.stub!(:find).and_return(@ticket)
    
    @project = mock_model(Project, :tickets => @tickets)
    Project.stub!(:find).and_return(@project)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => '1', :ticket_id => '1', :project_id => '1'
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the attachment requested" do
    @attachments.should_receive(:select).and_return([@attachment])
    do_get
  end
  
  it "should render the found attachment as xml" do
    @attachment.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end