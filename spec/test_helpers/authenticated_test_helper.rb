module AuthenticatedTestHelper
  def login_as(user)
    User.stub!(:find_by_id).and_return(user)
    request.session[:user] = user.id
  end
  
  def login_with_mocked_user
    @user = mock_model(User)
    login_as @user
  end
  
  def mock_user_with_permission_to(permission)
    user = mock_model(User)
    user.should_receive(:has_permission_to?).with(permission, an_instance_of(Hash)).and_return(true)
    user
  end
end