require File.dirname(__FILE__) + '/../spec_helper'

describe ChangesetsController, "#route_for" do

  it "should map { :controller => 'changesets', :action => 'index', :project_id => 1 } to /project/1/changesets" do
    route_for(:controller => "changesets", :action => "index", :project_id => 1).should == "/projects/1/changesets"
  end
  
  it "should map { :controller => 'changesets', :action => 'create', :project_id => 1 } to /projects/1/changesets" do
    route_for(:controller => "changesets", :action => "create", :project_id => '1').should == "/projects/1/changesets"
  end
  
  it "should map { :controller => 'changesets', :action => 'show', :id => 1, :project_id => 1 } to /projects/1/changesets/1" do
    route_for(:controller => "changesets", :action => "show", :id => 1, :project_id => 1).should == "/projects/1/changesets/1"
  end
end

describe ChangesetsController, "handling GET /projects/1/changesets" do

  before do
    @changeset = mock_model(Changeset)
    @changesets = [@changeset]
    @changesets.stub!(:paginate).and_return(@changesets)
    
    @project = mock_model(Project, :changesets => @changesets)
    Project.stub!(:find).and_return(@project)
    
    login_as mock_user_with_permission_to(:view_changesets)
  end
  
  def do_get
    get :index, :project_id => 1
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should render index template" do
    do_get
    response.should render_template('index')
  end
  
  it "should find all changesets" do
    @project.should_receive(:changesets).and_return(@changesets)
    do_get
  end
  
  it "should assign the found changesets for the view" do
    do_get
    assigns[:changesets].should == [@changeset]
  end
end

describe ChangesetsController, "handling GET /projects/1/changesets.xml" do

  before do
    @changeset = mock_model(Changeset)
    @changesets = [@changeset]
    @changesets.stub!(:paginate).and_return(@changesets)
    @changesets.stub!(:to_xml).and_return('XML')
    
    @project = mock_model(Project, :changesets => @changesets)
    Project.stub!(:find).and_return(@project)
    
    login_as mock_user_with_permission_to(:view_changesets)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index, :project_id => 1
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all changesets" do
    @project.should_receive(:changesets).and_return(@changesets)
    do_get
  end
  
  it "should render the found changesets as xml" do
    @changesets.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe ChangesetsController, "handling GET /projects/1/changesets/1" do

  before do
    @diffable_change = mock_model(Change, :status => 'M', :diffable? => true)
    @undiffable_change = mock_model(Change, :status => 'A')
    
    @changes = mock_association(@diffable_change, @undiffable_change)
    
    @changeset = mock_model(Changeset, :changes => @changes)
    @changesets = [@changeset]
    @changesets.stub!(:find_by_revision).and_return(@changeset)
    
    @project = mock_model(Project, :changesets => @changesets)
    Project.stub!(:find).and_return(@project)
    
    login_as mock_user_with_permission_to(:view_changesets)
  end
  
  def do_get
    get :show, :id => "1", :project_id => 1
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render show template" do
    do_get
    response.should render_template('show')
  end
  
  it "should find the changeset requested" do
    @project.should_receive(:changesets).and_return(@changesets)
    @changesets.should_receive(:find_by_revision).and_return(@changeset)
    do_get
  end
  
  it "should assign the found changeset for the view" do
    do_get
    assigns[:changeset].should equal(@changeset)
  end
  
  it "should select all diffable changes" do
    do_get
    assigns[:diffable_changes].should eql([@diffable_change])
  end
end

describe ChangesetsController, "handling GET /projects/1/changesets/1.xml" do

  before do
    @changes = mock_association(mock_model(Change, :status => 'A'))
    
    @changeset = mock_model(Changeset, :changes => @changes, :to_xml => 'XML')
    @changesets = [@changeset]
    @changesets.stub!(:find_by_revision).and_return(@changeset)
    
    @project = mock_model(Project, :changesets => @changesets)
    Project.stub!(:find).and_return(@project)
    
    login_as mock_user_with_permission_to(:view_changesets)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1", :project_id => 1
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the changeset requested" do
    @project.should_receive(:changesets).and_return(@changesets)
    @changesets.should_receive(:find_by_revision).and_return(@changeset)
    do_get
  end
  
  it "should render the found changeset as xml" do
    @changeset.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe ChangesetsController, "handling POST /projects/1/changesets" do

  before do
    @changeset = mock_model(Changeset, :to_param => "1", :save => true)
    Changeset.stub!(:new).and_return(@changeset)
    
    @project = mock_model(Project)
    Project.stub!(:find).and_return(@project)
    
    @params = {}
    
    login_as mock_user_with_permission_to(:add_changesets)
  end
  
  def do_post
    @request.env["HTTP_ACCEPT"] = "application/xml"
    post :create, :project_id => 1, :changeset => @params
  end
  
  it "should create a new changeset" do
    Changeset.should_receive(:new).with(@params).and_return(@changeset)
    do_post
  end
end
