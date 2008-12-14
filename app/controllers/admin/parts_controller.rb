class Admin::PartsController < AdminAreaController

  def index
    @current_part = Part.find_by_parent_id(nil)
    @projects = Project.find(:all, :order => :name)
    @part  = Part.new(params[:part])
    
    if request.post? && @part.save
       redirect_to :action => 'index'
    end
  end
  
  def edit
    @part = Part.find(params[:id])
    @part.attributes = params[:part]
    if request.post? && @part.save
      redirect_to :action => 'index'
    end
  end
  
  def delete
    if request.post?
      part = Part.find(params[:id]) rescue nil
      part.destroy if part      
    end
    redirect_to :action => 'index'
  end
end
