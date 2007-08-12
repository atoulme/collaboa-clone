ActionController::Routing::Routes.draw do |map|
  map.resources :attachments

  map.resources :repositories

  # The priority is based upon order of creation: first created -> highest priority.
  map.home '/', :controller => 'projects', :action => 'index'
  map.login 'login/', :controller => 'sessions', :action => 'new'
  map.logout 'logout/', :controller => 'sessions', :action => 'destroy'
  map.activate_user 'users/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.resources :users, :sessions
  map.resources :projects do |project|
    project.resources :changesets
    project.resources :milestones
    project.resource :repository
    project.resources :tickets do |ticket|
      ticket.resources :attachments
    end
    project.resource :search, :controller => 'search'
  end
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
