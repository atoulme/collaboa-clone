class Admin::UsersController < AdminAreaController

  def index
    @users = User.paginate :page => params[:page], :per_page => 50
  end

  def edit
    @user = User.find(params[:id])
    @user.attributes = params[:user]
    if request.post? && @user.save
      redirect_to :action => 'index'
    end
  end
  
  def delete
    if request.post?
      user = User.find(params[:id])
      user.destroy
      redirect_to :action => 'index'
    end
  end

  def rights_edits
    return unless request.post?
    params[:user].each_pair {|user_id, admin| u = User.find_by_id(user_id) ; u.admin = admin[:admin] ; u.save}
    params[:rights].each_pair {|rights_id, admin| r = UserProject.find_by_id(rights_id) ; r.project_admin = admin[:project_admin] ; r.save}
    redirect_to :controller => "admin/users", :action => 'index'
  end
end
