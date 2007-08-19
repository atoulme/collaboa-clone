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
    @projects = mock_association(mock_model(Project))
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
    @projects = mock_association(@project)
    @projects.stub!(:find).and_return(@project)
    
    @user = mock_model(User, :projects => @projects)
  end
  
  def do_get
    get :show, :id => "1"
  end

  it "should find the requested project" do
    @user.stub!(:has_permission_to?).and_return(true)
    login_as @user
    
    @user.should_receive(:projects).and_return(@projects)
    @projects.should_receive(:find).and_return(@project)
    
    do_get
  end

  it "should redirect to project changesets if user has permission" do
    @user.should_receive(:has_permission_to?).with(:view_changesets, :for => @project).and_return(true)
    login_as @user
    
    do_get
    response.should redirect_to(project_changesets_path(@project))
  end
   
  it "should redirect to project repository if user has permission" do
     @user.should_receive(:has_permission_to?).with(:view_changesets, :for => @project).and_return(false)
     @user.should_receive(:has_permission_to?).with(:view_repository, :for => @project).and_return(true)
     login_as @user

     do_get
     response.should redirect_to(project_repository_path(@project))
  end
    
  it "should redirect to project milestones if user has permission" do
      @user.should_receive(:has_permission_to?).with(:view_changesets, :for => @project).and_return(false)
      @user.should_receive(:has_permission_to?).with(:view_repository, :for => @project).and_return(false)
      @user.should_receive(:has_permission_to?).with(:view_milestones, :for => @project).and_return(true)
      login_as @user

      do_get
      response.should redirect_to(project_milestones_path(@project))
    end
     
  it "should redirect to project tickets if user has permission" do
       @user.should_receive(:has_permission_to?).with(:view_changesets, :for => @project).and_return(false)
       @user.should_receive(:has_permission_to?).with(:view_repository, :for => @project).and_return(false)
       @user.should_receive(:has_permission_to?).with(:view_milestones, :for => @project).and_return(false)
       @user.should_receive(:has_permission_to?).with(:view_tickets, :for => @project).and_return(true)
       login_as @user

       do_get
       response.should redirect_to(project_tickets_path(@project))
    end
      
  it "should redirect to a new project ticket if user has permission" do
      @user.should_receive(:has_permission_to?).with(:view_changesets, :for => @project).and_return(false)
      @user.should_receive(:has_permission_to?).with(:view_repository, :for => @project).and_return(false)
      @user.should_receive(:has_permission_to?).with(:view_milestones, :for => @project).and_return(false)
      @user.should_receive(:has_permission_to?).with(:view_tickets, :for => @project).and_return(false)
      @user.should_receive(:has_permission_to?).with(:add_tickets, :for => @project).and_return(true)
      login_as @user

      do_get
      response.should redirect_to(new_project_ticket_path(@project))
    end
    
  it "should redirect to login page if user doesn't have any permissions" do
      @user.should_receive(:has_permission_to?).with(:view_changesets, :for => @project).and_return(false)
      @user.should_receive(:has_permission_to?).with(:view_repository, :for => @project).and_return(false)
      @user.should_receive(:has_permission_to?).with(:view_milestones, :for => @project).and_return(false)
      @user.should_receive(:has_permission_to?).with(:view_tickets, :for => @project).and_return(false)
      @user.should_receive(:has_permission_to?).with(:add_tickets, :for => @project).and_return(false)
      login_as @user

      do_get
      response.should redirect_to(login_path)
    end
end

describe ProjectsController, "handling GET /projects/1.xml" do

  before do
    @project = mock_model(Project, :to_xml => "XML")
    @projects = mock_association(@project)
    @projects.stub!(:find).and_return(@project)
    
    @user = mock_model(User, :projects => @projects)
    login_as @user
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
    @user.should_receive(:projects).and_return(@projects)
    @projects.should_receive(:find).with('1').and_return(@project)
    do_get
  end
  
  it "should render the found project as xml" do
    @project.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end