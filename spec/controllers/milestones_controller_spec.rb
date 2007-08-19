require File.dirname(__FILE__) + '/../spec_helper'

describe MilestonesController, "#route_for" do

  it "should map { :controller => 'milestones', :action => 'index' } to /milestones" do
    route_for(:controller => "milestones", :action => "index").should == "/milestones"
  end
end

describe MilestonesController, "handling GET /milestones" do

  before do
    @milestone = mock_model(Milestone)
    @milestones = mock_association(@milestone)
    @milestones.stub!(:find).and_return(@milestones)
    
    @project = mock_model(Project, :milestones => @milestones)
    Project.stub!(:find).and_return(@project)
    
    Status.stub!(:unresolved_status_ids).and_return([1, 2, 3])
    Status.stub!(:resolved_status_ids).and_return([1, 2, 3])
    
    login_as mock_user_with_permission_to(:view_milestones)
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
    @project.should_receive(:milestones).and_return(@milestones)
    @milestones.should_receive(:find).and_return(@milestones)
    do_get
  end
  
  it "should assign the found milestones for the view" do
    do_get
    assigns[:milestones].should == @milestones
  end
  
  it "should assign all unresolved statuses" do
    Status.should_receive(:unresolved_status_ids).and_return([1, 2, 3])
    do_get
    assigns[:unresolved_status_ids].should == '1,2,3'
  end
  
  it "should assign all resolved statuses" do
    Status.should_receive(:resolved_status_ids).and_return([1, 2, 3])
    do_get
    assigns[:resolved_status_ids].should == '1,2,3'
  end
end

describe MilestonesController, " handling GET /milestones.xml" do

  before do
    @milestone = mock_model(Milestone, :to_xml => true)
    @milestones = mock_association(@milestone, :to_xml => 'XML')
    @milestones.stub!(:find).and_return(@milestones)
    
    @project = mock_model(Project, :milestones => @milestones)
    Project.stub!(:find).and_return(@project)
    
    login_as mock_user_with_permission_to(:view_milestones)
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
    @project.should_receive(:milestones).and_return(@milestones)
    @milestones.should_receive(:find).and_return(@milestones)
    do_get
  end
  
  it "should render the found milestones as xml" do
    @milestones.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end