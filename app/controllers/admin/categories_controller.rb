class Admin::CategoriesController < AdminAreaController

  def index
  end

  def create
    return unless request.post?
    category = Category.new(params[:category])
    category.save!
    flash[:notice] = "The category was successfully created"
    redirect_to :action => "index"
  end


  def edit
    @category = Category.find_by_id(params[:id])
    return unless request.post?
    @category.attributes = params[:category]
    @category.save!
    flash[:notice] = "The category was successfully modified"
    redirect_to :action => "index"
  end

  def delete
    @category = Category.find_by_id(params[:id])
    @category.destroy
    flash[:notice] = "The category was successfully deleted"
    redirect_to :action => "index"
  end
end
