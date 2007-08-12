require File.dirname(__FILE__) + '/../spec_helper'

describe ChangesetsController, "#route_for" do

  it "should map { :controller => 'changesets', :action => 'index' } to /changesets" do
    route_for(:controller => "changesets", :action => "index").should == "/changesets"
  end
  
  it "should map { :controller => 'changesets', :action => 'new' } to /changesets/new" do
    route_for(:controller => "changesets", :action => "new").should == "/changesets/new"
  end
  
  it "should map { :controller => 'changesets', :action => 'show', :id => 1 } to /changesets/1" do
    route_for(:controller => "changesets", :action => "show", :id => 1).should == "/changesets/1"
  end
  
  it "should map { :controller => 'changesets', :action => 'edit', :id => 1 } to /changesets/1/edit" do
    route_for(:controller => "changesets", :action => "edit", :id => 1).should == "/changesets/1/edit"
  end
  
  it "should map { :controller => 'changesets', :action => 'update', :id => 1} to /changesets/1" do
    route_for(:controller => "changesets", :action => "update", :id => 1).should == "/changesets/1"
  end
  
  it "should map { :controller => 'changesets', :action => 'destroy', :id => 1} to /changesets/1" do
    route_for(:controller => "changesets", :action => "destroy", :id => 1).should == "/changesets/1"
  end
  
end

describe ChangesetsController, "handling GET /changesets" do

  before do
    @changeset = mock_model(Changeset)
    Changeset.stub!(:find).and_return([@changeset])
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
  
  it "should find all changesets" do
    Changeset.should_receive(:find).with(:all).and_return([@changeset])
    do_get
  end
  
  it "should assign the found changesets for the view" do
    do_get
    assigns[:changesets].should == [@changeset]
  end
end

describe ChangesetsController, "handling GET /changesets.xml" do

  before do
    @changeset = mock_model(Changeset, :to_xml => "XML")
    Changeset.stub!(:find).and_return(@changeset)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all changesets" do
    Changeset.should_receive(:find).with(:all).and_return([@changeset])
    do_get
  end
  
  it "should render the found changesets as xml" do
    @changeset.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe ChangesetsController, "handling GET /changesets/1" do

  before do
    @changeset = mock_model(Changeset)
    Changeset.stub!(:find).and_return(@changeset)
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
  
  it "should find the changeset requested" do
    Changeset.should_receive(:find).with("1").and_return(@changeset)
    do_get
  end
  
  it "should assign the found changeset for the view" do
    do_get
    assigns[:changeset].should equal(@changeset)
  end
end

describe ChangesetsController, "handling GET /changesets/1.xml" do

  before do
    @changeset = mock_model(Changeset, :to_xml => "XML")
    Changeset.stub!(:find).and_return(@changeset)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the changeset requested" do
    Changeset.should_receive(:find).with("1").and_return(@changeset)
    do_get
  end
  
  it "should render the found changeset as xml" do
    @changeset.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe ChangesetsController, "handling GET /changesets/new" do

  before do
    @changeset = mock_model(Changeset)
    Changeset.stub!(:new).and_return(@changeset)
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
  
  it "should create an new changeset" do
    Changeset.should_receive(:new).and_return(@changeset)
    do_get
  end
  
  it "should not save the new changeset" do
    @changeset.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new changeset for the view" do
    do_get
    assigns[:changeset].should equal(@changeset)
  end
end

describe ChangesetsController, "handling GET /changesets/1/edit" do

  before do
    @changeset = mock_model(Changeset)
    Changeset.stub!(:find).and_return(@changeset)
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
  
  it "should find the changeset requested" do
    Changeset.should_receive(:find).and_return(@changeset)
    do_get
  end
  
  it "should assign the found Changeset for the view" do
    do_get
    assigns[:changeset].should equal(@changeset)
  end
end

describe ChangesetsController, "handling POST /changesets" do

  before do
    @changeset = mock_model(Changeset, :to_param => "1", :save => true)
    Changeset.stub!(:new).and_return(@changeset)
    @params = {}
  end
  
  def do_post
    post :create, :changeset => @params
  end
  
  it "should create a new changeset" do
    Changeset.should_receive(:new).with(@params).and_return(@changeset)
    do_post
  end

  it "should redirect to the new changeset" do
    do_post
    response.should redirect_to(changeset_url("1"))
  end
end

describe ChangesetsController, "handling PUT /changesets/1" do

  before do
    @changeset = mock_model(Changeset, :to_param => "1", :update_attributes => true)
    Changeset.stub!(:find).and_return(@changeset)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  it "should find the changeset requested" do
    Changeset.should_receive(:find).with("1").and_return(@changeset)
    do_update
  end

  it "should update the found changeset" do
    @changeset.should_receive(:update_attributes)
    do_update
    assigns(:changeset).should equal(@changeset)
  end

  it "should assign the found changeset for the view" do
    do_update
    assigns(:changeset).should equal(@changeset)
  end

  it "should redirect to the changeset" do
    do_update
    response.should redirect_to(changeset_url("1"))
  end
end

describe ChangesetsController, "handling DELETE /changesets/1" do

  before do
    @changeset = mock_model(Changeset, :destroy => true)
    Changeset.stub!(:find).and_return(@changeset)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the changeset requested" do
    Changeset.should_receive(:find).with("1").and_return(@changeset)
    do_delete
  end
  
  it "should call destroy on the found changeset" do
    @changeset.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the changesets list" do
    do_delete
    response.should redirect_to(changesets_url)
  end
end
