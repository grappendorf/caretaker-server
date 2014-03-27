CoyohoServer::Application.routes.draw do

	root to: 'dashboards#default'

	devise_for :users, path: 'session'

	resources :users

	resources :dashboards do
		collection do
			get 'names'
			get :default
		end
		get ':type/new' => 'widgets#new', constraints: {type: /#{Widget.models_paths.join '|'}/}, as: :new_widget
		post ':type' => 'widgets#create', constraints: {type: /#{Widget.models_paths.join '|'}/}
		put ':type/:id' => 'widgets#update', constraints: {type: /#{(['widgets'] + Widget.models_paths).join '|'}/}
		patch ':type/:id' => 'widgets#update', constraints: {type: /#{(['widgets'] + Widget.models_paths).join '|'}/}
		resources :widgets, only: [:show, :edit, :destroy]
	end

	get '/:type/new' => 'devices#new', constraints: {type: /#{Device.models_paths.join '|'}/}, as: :new_device
	resources :devices, except: :new do
		collection do
			get 'names'
		end
	end

	resources :device_scripts do
		member do
			put :enable
			put :disable
		end
	end

	resources :buildings do
		resources :floors do
			resources :rooms
		end
	end
	get '/floors' => 'floors#index', as: :floors
	get '/rooms' => 'rooms#index', as: :rooms

	get '/settings' => 'settings#edit'

	get '/help/about' => 'help#about'

	get '/invalid' => 'catchall#index', as: :invalid

end
