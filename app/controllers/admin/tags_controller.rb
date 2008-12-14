class Admin::TagsController < AdminAreaController

  def index
    @tags = Tag.find(:all)
  end

  def create
    return unless request.post?
    tag = Tag.new(params[:tag])
    tag.save!
    flash[:notice] = "The tag was successfully created"
    redirect_to :action => "index"
  end


  def edit
    @tag = Tag.find_by_id(params[:id])
    return unless request.post?
    @tag.attributes = params[:tag]
    @tag.save!
    flash[:notice] = "The tag was successfully modified"
    redirect_to :action => "index"
  end

  def delete
    @tag = Tag.find_by_id(params[:id])
    @tag.destroy
    flash[:notice] = "The tag was successfully deleted"
    redirect_to :action => "index"
  end
end
