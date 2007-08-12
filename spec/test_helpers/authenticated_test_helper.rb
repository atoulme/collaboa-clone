module AuthenticatedTestHelper
  def login_as(user)
    User.stub!(:find_by_id).and_return(user)
    request.session[:user] = user.id
  end
  
  def login_with_mocked_user
    @user = mock_model(User)
    login_as @user
  end
end