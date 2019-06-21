Rails.application.routes.draw do
  resources :sub_categories
  resources :categories
  	root 'pages#index'
  	get 'results', to: "pages#results"
 	resources :affiliates
  	resources :items

  	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end