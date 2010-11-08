Cms3::Application.routes.draw do
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

  resources :sites

  resources :login do
    collection do
      post :index
      post :logout
    end
  end

  resources :layouts do
    member do
      get :administer_blocks
      put :establish_base
      post :update_blocks
    end
  end

  resources :users do
    member do
      get :activate
      get :save_new_password
      post :save_new_password
    end

    collection do
      get :forget_password
      post :remember_password
    end
  end
  
  resources :groups do
    member do
      get :add_user
      post :add_user_to_group
      delete :delete_from_group
    end
  end

  resources :countries do
    resources :provinces
  end

  resources :authors
  resources :books do
    collection do
      get :add_author
      post :add_author_to_book
      delete :delete_author_from_book
      get :add_publisher
      post :add_publisher_to_book
      delete :delete_publisher_from_book
    end
    member do
      post :comment
      get :edit_comment
      put :update_comment
    end

    resources :critics do
      collection do
        post :write_your_critic
      end
    end
  end
  
  resources :publishers
  resources :noticias do
    collection do
      get :list
    end
    member do
      post :comment
      get :edit_comment
      put :update_comment
    end
  end

  resources :blogs do
    resources :posts do
      collection do
        get :list
      end
      member do
        post :comment
        put :edit_comment
      end
    end
  end
end
