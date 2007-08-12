require File.dirname(__FILE__) + '/../spec_helper'

describe MilestonesController, "#route_for" do

  it "should map { :controller => 'milestones', :action => 'index' } to /milestones" do
    route_for(:controller => "milestones", :action => "index").should == "/milestones"
  end
  
  it "should map { :controller => 'milestones', :action => 'new' } to /milestones/new" do
    route_for(:controller => "milestones", :action => "new").should == "/milestones/new"
  end
  
  it "should map { :controller => 'milestones', :action => 'show', :id => 1 } to /milestones/1" do
    route_for(:controller => "milestones", :action => "show", :id => 1).should == "/milestones/1"
  end
  
  it "should map { :controller => 'milestones', :action => 'edit', :id => 1 } to /milestones/1/edit" do
    route_for(:controller => "milestones", :action => "edit", :id => 1).should == "/milestones/1/edit"
  end
  
  it "should map { :controller => 'milestones', :action => 'update', :id => 1} to /milestones/1" do
    route_for(:controller => "milestones", :action => "update", :id => 1).should == "/milestones/1"
  end
  
  it "should map { :controller => 'milestones', :action => 'destroy', :id => 1} to /milestones/1" do
    route_for(:controller => "milestones", :action => "destroy", :id => 1).should == "/milestones/1"
  end
  
end

describe MilestonesController, "handling GET /milestones" do

  before do
    @milestone = mock_model(Milestone)
    Milestone.stub!(:find).and_return([@milestone])
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
  
  it "should find all milestones" do
    Milestone.should_receive(:find).with(:all).and_return([@milestone])
    do_get
  end
  
  it "should assign the found milestones for the view" do
    do_get
    assigns[:milestones].should == [@milestone]
  end
end

describe MilestonesController, "handling GET /milestones.xml" do

  before do
    @milestone = mock_model(Milestone, :to_xml => "XML")
    Milestone.stub!(:find).and_return(@milestone)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all milestones" do
    Milestone.should_receive(:find).with(:all).and_return([@milestone])
    do_get
  end
  
  it "should render the found milestones as xml" do
    @milestone.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe MilestonesController, "handling GET /milestones/1" do

  before do
    @milestone = mock_model(Milestone)
    Milestone.stub!(:find).and_return(@milestone)
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
  
  it "should find the milestone requested" do
    Milestone.should_receive(:find).with("1").and_return(@milestone)
    do_get
  end
  
  it "should assign the found milestone for the view" do
    do_get
    assigns[:milestone].should equal(@milestone)
  end
end

describe MilestonesController, "handling GET /milestones/1.xml" do

  before do
    @milestone = mock_model(Milestone, :to_xml => "XML")
    Milestone.stub!(:find).and_return(@milestone)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the milestone requested" do
    Milestone.should_receive(:find).with("1").and_return(@milestone)
    do_get
  end
  
  it "should render the found milestone as xml" do
    @milestone.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe MilestonesController, "handling GET /milestones/new" do

  before do
    @milestone = mock_model(Milestone)
    Milestone.stub!(:new).and_return(@milestone)
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
  
  it "should create an new milestone" do
    Milestone.should_receive(:new).and_return(@milestone)
    do_get
  end
  
  it "should not save the new milestone" do
    @milestone.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new milestone for the view" do
    do_get
    assigns[:milestone].should equal(@milestone)
  end
end

describe MilestonesController, "handling GET /milestones/1/edit" do

  before do
    @milestone = mock_model(Milestone)
    Milestone.stub!(:find).and_return(@milestone)
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
  
  it "should find the milestone requested" do
    Milestone.should_receive(:find).and_return(@milestone)
    do_get
  end
  
  it "should assign the found Milestone for the view" do
    do_get
    assigns[:milestone].should equal(@milestone)
  end
end

describe MilestonesController, "handling POST /milestones" do

  before do
    @milestone = mock_model(Milestone, :to_param => "1", :save => true)
    Milestone.stub!(:new).and_return(@milestone)
    @params = {}
  end
  
  def do_post
    post :create, :milestone => @params
  end
  
  it "should create a new milestone" do
    Milestone.should_receive(:new).with(@params).and_return(@milestone)
    do_post
  end

  it "should redirect to the new milestone" do
    do_post
    response.should redirect_to(milestone_url("1"))
  end
end

describe MilestonesController, "handling PUT /milestones/1" do

  before do
    @milestone = mock_model(Milestone, :to_param => "1", :update_attributes => true)
    Milestone.stub!(:find).and_return(@milestone)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  it "should find the milestone requested" do
    Milestone.should_receive(:find).with("1").and_return(@milestone)
    do_update
  end

  it "should update the found milestone" do
    @milestone.should_receive(:update_attributes)
    do_update
    assigns(:milestone).should equal(@milestone)
  end

  it "should assign the found milestone for the view" do
    do_update
    assigns(:milestone).should equal(@milestone)
  end

  it "should redirect to the milestone" do
    do_update
    response.should redirect_to(milestone_url("1"))
  end
end

describe MilestonesController, "handling DELETE /milestones/1" do

  before do
    @milestone = mock_model(Milestone, :destroy => true)
    Milestone.stub!(:find).and_return(@milestone)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the milestone requested" do
    Milestone.should_receive(:find).with("1").and_return(@milestone)
    do_delete
  end
  
  it "should call destroy on the found milestone" do
    @milestone.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the milestones list" do
    do_delete
    response.should redirect_to(milestones_url)
  end
end
