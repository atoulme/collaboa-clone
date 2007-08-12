require File.dirname(__FILE__) + '/../spec_helper'

describe AttachmentsController, "#route_for" do

  it "should map { :controller => 'attachments', :action => 'index' } to /attachments" do
    route_for(:controller => "attachments", :action => "index").should == "/attachments"
  end
  
  it "should map { :controller => 'attachments', :action => 'new' } to /attachments/new" do
    route_for(:controller => "attachments", :action => "new").should == "/attachments/new"
  end
  
  it "should map { :controller => 'attachments', :action => 'show', :id => 1 } to /attachments/1" do
    route_for(:controller => "attachments", :action => "show", :id => 1).should == "/attachments/1"
  end
  
  it "should map { :controller => 'attachments', :action => 'edit', :id => 1 } to /attachments/1/edit" do
    route_for(:controller => "attachments", :action => "edit", :id => 1).should == "/attachments/1/edit"
  end
  
  it "should map { :controller => 'attachments', :action => 'update', :id => 1} to /attachments/1" do
    route_for(:controller => "attachments", :action => "update", :id => 1).should == "/attachments/1"
  end
  
  it "should map { :controller => 'attachments', :action => 'destroy', :id => 1} to /attachments/1" do
    route_for(:controller => "attachments", :action => "destroy", :id => 1).should == "/attachments/1"
  end
  
end

describe AttachmentsController, "handling GET /attachments" do

  before do
    @attachment = mock_model(Attachment)
    Attachment.stub!(:find).and_return([@attachment])
  end
  
  def do_get
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should render index template" do
    do_get
    response.should render_template('index')
  end
  
  it "should find all attachments" do
    Attachment.should_receive(:find).with(:all).and_return([@attachment])
    do_get
  end
  
  it "should assign the found attachments for the view" do
    do_get
    assigns[:attachments].should == [@attachment]
  end
end

describe AttachmentsController, "handling GET /attachments.xml" do

  before do
    @attachment = mock_model(Attachment, :to_xml => "XML")
    Attachment.stub!(:find).and_return(@attachment)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all attachments" do
    Attachment.should_receive(:find).with(:all).and_return([@attachment])
    do_get
  end
  
  it "should render the found attachments as xml" do
    @attachment.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe AttachmentsController, "handling GET /attachments/1" do

  before do
    @attachment = mock_model(Attachment)
    Attachment.stub!(:find).and_return(@attachment)
  end
  
  def do_get
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render show template" do
    do_get
    response.should render_template('show')
  end
  
  it "should find the attachment requested" do
    Attachment.should_receive(:find).with("1").and_return(@attachment)
    do_get
  end
  
  it "should assign the found attachment for the view" do
    do_get
    assigns[:attachment].should equal(@attachment)
  end
end

describe AttachmentsController, "handling GET /attachments/1.xml" do

  before do
    @attachment = mock_model(Attachment, :to_xml => "XML")
    Attachment.stub!(:find).and_return(@attachment)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the attachment requested" do
    Attachment.should_receive(:find).with("1").and_return(@attachment)
    do_get
  end
  
  it "should render the found attachment as xml" do
    @attachment.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe AttachmentsController, "handling GET /attachments/new" do

  before do
    @attachment = mock_model(Attachment)
    Attachment.stub!(:new).and_return(@attachment)
  end
  
  def do_get
    get :new
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render new template" do
    do_get
    response.should render_template('new')
  end
  
  it "should create an new attachment" do
    Attachment.should_receive(:new).and_return(@attachment)
    do_get
  end
  
  it "should not save the new attachment" do
    @attachment.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new attachment for the view" do
    do_get
    assigns[:attachment].should equal(@attachment)
  end
end

describe AttachmentsController, "handling GET /attachments/1/edit" do

  before do
    @attachment = mock_model(Attachment)
    Attachment.stub!(:find).and_return(@attachment)
  end
  
  def do_get
    get :edit, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render edit template" do
    do_get
    response.should render_template('edit')
  end
  
  it "should find the attachment requested" do
    Attachment.should_receive(:find).and_return(@attachment)
    do_get
  end
  
  it "should assign the found Attachment for the view" do
    do_get
    assigns[:attachment].should equal(@attachment)
  end
end

describe AttachmentsController, "handling POST /attachments" do

  before do
    @attachment = mock_model(Attachment, :to_param => "1", :save => true)
    Attachment.stub!(:new).and_return(@attachment)
    @params = {}
  end
  
  def do_post
    post :create, :attachment => @params
  end
  
  it "should create a new attachment" do
    Attachment.should_receive(:new).with(@params).and_return(@attachment)
    do_post
  end

  it "should redirect to the new attachment" do
    do_post
    response.should redirect_to(attachment_url("1"))
  end
end

describe AttachmentsController, "handling PUT /attachments/1" do

  before do
    @attachment = mock_model(Attachment, :to_param => "1", :update_attributes => true)
    Attachment.stub!(:find).and_return(@attachment)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  it "should find the attachment requested" do
    Attachment.should_receive(:find).with("1").and_return(@attachment)
    do_update
  end

  it "should update the found attachment" do
    @attachment.should_receive(:update_attributes)
    do_update
    assigns(:attachment).should equal(@attachment)
  end

  it "should assign the found attachment for the view" do
    do_update
    assigns(:attachment).should equal(@attachment)
  end

  it "should redirect to the attachment" do
    do_update
    response.should redirect_to(attachment_url("1"))
  end
end

describe AttachmentsController, "handling DELETE /attachments/1" do

  before do
    @attachment = mock_model(Attachment, :destroy => true)
    Attachment.stub!(:find).and_return(@attachment)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the attachment requested" do
    Attachment.should_receive(:find).with("1").and_return(@attachment)
    do_delete
  end
  
  it "should call destroy on the found attachment" do
    @attachment.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the attachments list" do
    do_delete
    response.should redirect_to(attachments_url)
  end
end
