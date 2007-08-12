require File.dirname(__FILE__) + '/../spec_helper'

describe ProjectsController, "#route_for" do

  it "should map { :controller => 'projects', :action => 'index' } to /" do
    route_for(:controller => "projects", :action => "index").should == "/"
  end
  
  it "should map { :controller => 'projects', :action => 'new' } to /projects/new" do
    route_for(:controller => "projects", :action => "new").should == "/projects/new"
  end
  
  it "should map { :controller => 'projects', :action => 'show', :id => 1 } to /projects/1" do
    route_for(:controller => "projects", :action => "show", :id => 1).should == "/projects/1"
  end
  
  it "should map { :controller => 'projects', :action => 'edit', :id => 1 } to /projects/1/edit" do
    route_for(:controller => "projects", :action => "edit", :id => 1).should == "/projects/1/edit"
  end
  
  it "should map { :controller => 'projects', :action => 'update', :id => 1} to /projects/1" do
    route_for(:controller => "projects", :action => "update", :id => 1).should == "/projects/1"
  end
  
  it "should map { :controller => 'projects', :action => 'destroy', :id => 1} to /projects/1" do
    route_for(:controller => "projects", :action => "destroy", :id => 1).should == "/projects/1"
  end
  
end

describe ProjectsController, "handling GET /projects" do

  before do
    @projects = mock_association()
    @user = mock_model(User, :projects => @projects)
    login_as(@user)
  end
  
  def do_get
    get :index
  end
  
  it "should find all projects" do
    @user.should_receive(:projects).and_return(@projects)
    @projects.should_receive(:find).with(:all).and_return(@projects)
    do_get
  end
  
  it "should assign the found projects for the view" do
    do_get
    assigns[:projects].should == @projects
  end
end

describe ProjectsController, "handling GET /projects when current user has 2 or more projects" do

  before do
    @projects = mock_association(mock_model(Project), mock_model(Project))
    @user = mock_model(User, :projects => @projects)
    login_as(@user)
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
end

describe ProjectsController, "handling GET /projects when current user has 1 project" do

  before do
    @project = mock_model(Project)
    @projects = mock_association(@project)
    @user = mock_model(User, :projects => @projects)
    login_as(@user)
  end
  
  def do_get
    get :index
  end
  
  it "should redirect to project page" do
    do_get
    response.should redirect_to(project_path(@project))
  end
end

describe ProjectsController, "handling GET /projects when current user has no projects" do

  before do
    @projects = mock_association()
    @user = mock_model(User, :projects => @projects)
    login_as(@user)
  end
  
  def do_get
    get :index
  end
  
  it "should redirect to login page" do
    do_get
    response.should redirect_to(login_path())
  end
end

describe ProjectsController, "handling GET /projects.xml" do

  before do
    project = mock_model(Project, :to_xml => 'XML')
    @projects = mock_association(project)
    Project.stub!(:find).and_return(@projects)
    @projects.stub!(:to_xml).and_return('XML')
    
    @user = mock_model(User, :projects => @projects)
    login_as @user
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all projects" do
    @user.should_receive(:projects).and_return(@projects)
    @projects.should_receive(:find).with(:all).and_return(@projects)
    do_get
  end
  
  it "should render the found projects as xml" do
    @projects.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe ProjectsController, "handling GET /projects/1" do

  before do
    @project = mock_model(Project)
    Project.stub!(:find).and_return(@project)
    
    login_with_mocked_user
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
  
  it "should find the project requested" do
    Project.should_receive(:find).with("1").and_return(@project)
    do_get
  end
  
  it "should assign the found project for the view" do
    do_get
    assigns[:project].should equal(@project)
  end
end

describe ProjectsController, "handling GET /projects/1.xml" do

  before do
    @project = mock_model(Project, :to_xml => "XML")
    Project.stub!(:find).and_return(@project)
    
    login_with_mocked_user
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the project requested" do
    Project.should_receive(:find).with("1").and_return(@project)
    do_get
  end
  
  it "should render the found project as xml" do
    @project.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe ProjectsController, "handling GET /projects/new" do

  before do
    @project = mock_model(Project)
    Project.stub!(:new).and_return(@project)
    
    login_with_mocked_user
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
  
  it "should create an new project" do
    Project.should_receive(:new).and_return(@project)
    do_get
  end
  
  it "should not save the new project" do
    @project.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new project for the view" do
    do_get
    assigns[:project].should equal(@project)
  end
end

describe ProjectsController, "handling GET /projects/1/edit" do

  before do
    @project = mock_model(Project)
    Project.stub!(:find).and_return(@project)
    
    login_with_mocked_user
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
  
  it "should find the project requested" do
    Project.should_receive(:find).and_return(@project)
    do_get
  end
  
  it "should assign the found Project for the view" do
    do_get
    assigns[:project].should equal(@project)
  end
end

describe ProjectsController, "handling POST /projects" do

  before do
    @project = mock_model(Project, :to_param => "1", :save => true)
    Project.stub!(:new).and_return(@project)
    @params = {}
    
    login_with_mocked_user
  end
  
  def do_post
    post :create, :project => @params
  end
  
  it "should create a new project" do
    Project.should_receive(:new).with(@params).and_return(@project)
    do_post
  end

  it "should redirect to the new project" do
    do_post
    response.should redirect_to(project_url("1"))
  end
end

describe ProjectsController, "handling PUT /projects/1" do

  before do
    @project = mock_model(Project, :to_param => "1", :update_attributes => true)
    Project.stub!(:find).and_return(@project)
    
    login_with_mocked_user
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  it "should find the project requested" do
    Project.should_receive(:find).with("1").and_return(@project)
    do_update
  end

  it "should update the found project" do
    @project.should_receive(:update_attributes)
    do_update
    assigns(:project).should equal(@project)
  end

  it "should assign the found project for the view" do
    do_update
    assigns(:project).should equal(@project)
  end

  it "should redirect to the project" do
    do_update
    response.should redirect_to(project_url("1"))
  end
end

describe ProjectsController, "handling DELETE /projects/1" do

  before do
    @project = mock_model(Project, :destroy => true)
    Project.stub!(:find).and_return(@project)
    
    login_with_mocked_user
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the project requested" do
    Project.should_receive(:find).with("1").and_return(@project)
    do_delete
  end
  
  it "should call destroy on the found project" do
    @project.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the projects list" do
    do_delete
    response.should redirect_to(projects_url)
  end
end
