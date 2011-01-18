PlatForms2011::Application.routes.draw do
  devise_for :users
  
  resources :conferences do
    match "ical" => 'conferences#ical'
    resources :conference_participations
  end
  
  root :to => "welcome#hello"
  
  resources :categories, :only => [:show]
  
  scope "ws", :as => "ws", :defaults => { :format => 'json' } do
    resources :conferences, :only => [:create, :show, :update, :index, :destroy] do
      resources :attendees, :only => [:index, :create, :destroy]
    end
    resources :users, :path => "members", :only => [:create, :show, :update] do
      resources :contacts, :only => [:create, :index]
    end
    resources :categories, :only => [:index, :show, :create]
    resources :series, :only => [:index, :show, :create]
    match "/conferencesbycategory" => "categories#conferences"
    match "/search" => "search#search"
    match "/reset" => "maintenance#reset"
    match "/factorydefaults" => "maintenance#factorydefaults"    
  end
  
  

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
