require File.dirname(__FILE__) + '/../spec_helper'

describe RepositoriesController, "#route_for" do

  it "should map { :controller => 'repositories', :action => 'index' } to /repositories" do
    route_for(:controller => "repositories", :action => "index").should == "/repositories"
  end
  
  it "should map { :controller => 'repositories', :action => 'new' } to /repositories/new" do
    route_for(:controller => "repositories", :action => "new").should == "/repositories/new"
  end
  
  it "should map { :controller => 'repositories', :action => 'show', :id => 1 } to /repositories/1" do
    route_for(:controller => "repositories", :action => "show", :id => 1).should == "/repositories/1"
  end
  
  it "should map { :controller => 'repositories', :action => 'edit', :id => 1 } to /repositories/1/edit" do
    route_for(:controller => "repositories", :action => "edit", :id => 1).should == "/repositories/1/edit"
  end
  
  it "should map { :controller => 'repositories', :action => 'update', :id => 1} to /repositories/1" do
    route_for(:controller => "repositories", :action => "update", :id => 1).should == "/repositories/1"
  end
  
  it "should map { :controller => 'repositories', :action => 'destroy', :id => 1} to /repositories/1" do
    route_for(:controller => "repositories", :action => "destroy", :id => 1).should == "/repositories/1"
  end
  
end

describe RepositoriesController, "handling GET /repositories" do

  before do
    @repository = mock_model(Repository)
    Repository.stub!(:find).and_return([@repository])
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
  
  it "should find all repositories" do
    Repository.should_receive(:find).with(:all).and_return([@repository])
    do_get
  end
  
  it "should assign the found repositories for the view" do
    do_get
    assigns[:repositories].should == [@repository]
  end
end

describe RepositoriesController, "handling GET /repositories.xml" do

  before do
    @repository = mock_model(Repository, :to_xml => "XML")
    Repository.stub!(:find).and_return(@repository)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all repositories" do
    Repository.should_receive(:find).with(:all).and_return([@repository])
    do_get
  end
  
  it "should render the found repositories as xml" do
    @repository.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe RepositoriesController, "handling GET /repositories/1" do

  before do
    @repository = mock_model(Repository)
    Repository.stub!(:find).and_return(@repository)
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
  
  it "should find the repository requested" do
    Repository.should_receive(:find).with("1").and_return(@repository)
    do_get
  end
  
  it "should assign the found repository for the view" do
    do_get
    assigns[:repository].should equal(@repository)
  end
end

describe RepositoriesController, "handling GET /repositories/1.xml" do

  before do
    @repository = mock_model(Repository, :to_xml => "XML")
    Repository.stub!(:find).and_return(@repository)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the repository requested" do
    Repository.should_receive(:find).with("1").and_return(@repository)
    do_get
  end
  
  it "should render the found repository as xml" do
    @repository.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe RepositoriesController, "handling GET /repositories/new" do

  before do
    @repository = mock_model(Repository)
    Repository.stub!(:new).and_return(@repository)
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
  
  it "should create an new repository" do
    Repository.should_receive(:new).and_return(@repository)
    do_get
  end
  
  it "should not save the new repository" do
    @repository.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new repository for the view" do
    do_get
    assigns[:repository].should equal(@repository)
  end
end

describe RepositoriesController, "handling GET /repositories/1/edit" do

  before do
    @repository = mock_model(Repository)
    Repository.stub!(:find).and_return(@repository)
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
  
  it "should find the repository requested" do
    Repository.should_receive(:find).and_return(@repository)
    do_get
  end
  
  it "should assign the found Repository for the view" do
    do_get
    assigns[:repository].should equal(@repository)
  end
end

describe RepositoriesController, "handling POST /repositories" do

  before do
    @repository = mock_model(Repository, :to_param => "1", :save => true)
    Repository.stub!(:new).and_return(@repository)
    @params = {}
  end
  
  def do_post
    post :create, :repository => @params
  end
  
  it "should create a new repository" do
    Repository.should_receive(:new).with(@params).and_return(@repository)
    do_post
  end

  it "should redirect to the new repository" do
    do_post
    response.should redirect_to(repository_url("1"))
  end
end

describe RepositoriesController, "handling PUT /repositories/1" do

  before do
    @repository = mock_model(Repository, :to_param => "1", :update_attributes => true)
    Repository.stub!(:find).and_return(@repository)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  it "should find the repository requested" do
    Repository.should_receive(:find).with("1").and_return(@repository)
    do_update
  end

  it "should update the found repository" do
    @repository.should_receive(:update_attributes)
    do_update
    assigns(:repository).should equal(@repository)
  end

  it "should assign the found repository for the view" do
    do_update
    assigns(:repository).should equal(@repository)
  end

  it "should redirect to the repository" do
    do_update
    response.should redirect_to(repository_url("1"))
  end
end

describe RepositoriesController, "handling DELETE /repositories/1" do

  before do
    @repository = mock_model(Repository, :destroy => true)
    Repository.stub!(:find).and_return(@repository)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the repository requested" do
    Repository.should_receive(:find).with("1").and_return(@repository)
    do_delete
  end
  
  it "should call destroy on the found repository" do
    @repository.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the repositories list" do
    do_delete
    response.should redirect_to(repositories_url)
  end
end
