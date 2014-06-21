Mealness::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

  root :to => "home#index"

  get '/sitemap.xml' => 'sitemap#index', :as => :sitemap, :format => :xml
  get 'posts/:post_id' => 'home#post', :as => :post

  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # new_admin_eaten GET        /admin/eatens/new(.:format)               admin/eatens#new
  get 'admin/dishes/:dish_id/eatens/new' => 'admin/eatens#new', :as => :new_admin_dish_eaten
  get 'admin/ingredients/:ingredient_id/eatens/new' => 'admin/eatens#new', :as => :new_admin_ingredient_eaten
  get 'admin/rations/:ration_id/ingredients' => 'admin/ingredients#index', :as => :admin_ration_ingredients

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
