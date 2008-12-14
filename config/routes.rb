ActionController::Routing::Routes.draw do |map|
  # Add your own custom routes here.
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Here's a sample route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action
  
  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
 
  map.connect '', :controller => 'main', :action => 'index' 
  map.connect 'admin', :controller => 'admin/dashboard', :action => 'index'
  
  map.connect 'admin/projects/:action/:id', :controller => 'admin/projects'

  map.connect 'admin/milestones/:action', :controller => "admin/milestones"

  map.connect 'admin/categories/:action/:id', :controller => 'admin/categories'

  map.connect 'admin/tags/:action/:id', :controller => 'admin/tags'
  
  map.connect 'rss/tickets', :controller => 'rss', :action => 'tickets'

  map.connect ':project/repository/browse/*path', 
              :controller => 'repository', 
              :action => 'browse'
  
  map.connect 'repository/browse/*path', 
              :controller => 'repository', 
              :action => 'browse'
              
  # "Routing Error: Path components must occur last" :(
  #map.connect 'repository/browse/*path/rev/:rev', 
  #            :controller => 'repository', 
  #            :action => 'browse',
  #            :rev => /\d+/
              
  # TODO: Rework this into a general browse/view_file usable thing
  #map.connect 'repository/file/rev/:rev/*path', 
  #            :controller => 'repository', 
  #            :action => 'view_file',
  #            :rev => /\d+/

  map.connect ':project/repository/file/*path', 
              :controller => 'repository', 
              :action => 'view_file'
              
  map.connect 'repository/file/*path', 
              :controller => 'repository', 
              :action => 'view_file'
              
  map.connect ':project/repository/revisions/*path', 
              :controller => 'repository', 
              :action => 'revisions'

  map.connect 'repository/revisions/*path', 
              :controller => 'repository', 
              :action => 'revisions'

  map.connect ':project/repository/changesets', 
              :controller => 'repository', 
              :action => 'changesets'

  map.connect ':project/repository/changesets/:revision', 
              :controller => 'repository', 
              :action => 'show_changeset'

  map.connect 'repository/changesets/:revision', 
              :controller => 'repository', 
              :action => 'show_changeset'
                            
  map.connect ':project/tickets',
              :controller => 'tickets',
              :action => 'index'
  map.connect ':project/releases/:action/:id',
              :controller => 'releases'
              
  map.connect 'tickets',
              :controller => 'tickets'
                            
  map.connect ':project/tickets/new',
              :controller => 'tickets',
              :action => 'new'

  map.connect ':project/components/:action/:id',
              :controller => "components"

  map.connect ':project/tickets/:id',
              :controller => 'tickets',
              :action => 'show',
              :requirements => { :id => /\d+/ }

  map.connect 'tickets/:id',
              :controller => 'tickets',
              :action => 'show',
              :requirements => { :id => /\d+/ }

  map.connect ':project/milestones',
              :controller => 'milestones',
              :action => 'index'

  map.connect ':project/milestones/:id',
              :controller => 'milestones',
              :action => 'show'
  
  map.connect ':project/search',
              :controller => 'search'
            
  map.connect ':project',
              :controller => 'main'
  #map.projects 'projects', 
  #            :controller => "projects", 
  #            :action => 'index'

  
  map.connect ':controller/:action/:id'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  #map.connect ':controller/service.wsdl', :action => 'wsdl'

end
