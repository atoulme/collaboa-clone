class SearchController < ApplicationController
  before_filter :load_project
  
  def show
    # Check permissions for tickets and changesets
  end
  
  def new
    
  end
end
