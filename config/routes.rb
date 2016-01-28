CaretakerServer::Application.routes.draw do

  root to: 'app#index'

  get '/app' => 'app#index'
  get '/locale' => 'app#locale'
  get '/version' => 'app#version'

  devise_for :users, path: 'session', controllers: { sessions: 'sessions' }

  resources :users, defaults: { format: :json }

  resources :dashboards, defaults: { format: :json } do
    collection do
      get 'names'
      get :default
    end
    get ':type/new' => 'widgets#new', constraints: { type: /#{Widget.models_paths.join '|'}/ }, as: :new_widget
    post ':type' => 'widgets#create', constraints: { type: /#{Widget.models_paths.join '|'}/ }
    put ':type/:id' => 'widgets#update', constraints: { type: /#{(['widgets'] + Widget.models_paths).join '|'}/ }
    patch ':type/:id' => 'widgets#update', constraints: { type: /#{(['widgets'] + Widget.models_paths).join '|'}/ }
    resources :widgets, only: [:show, :edit, :destroy]
  end

  get '/:type/new' => 'devices#new', constraints: { type: /#{Device.models_paths.join '|'}/ },
      defaults: { format: :json }, as: :new_device

  post '/:type' => 'devices#create', constraints: { type: /#{Device.models_paths.join '|'}/ },
       defaults: { format: :json }, as: :create_device

  resources :devices, except: [:new, :create], defaults: { format: :json } do
    collection do
      get 'names'
    end
  end

  get '/cipcam_device/:id/image' => 'cipcam_device#image'

  scope '/philips_hue', defaults: { format: :json } do
    get '/bridge' => 'philips_hue#bridge'
    post '/register' => 'philips_hue#register'
    post '/unregister' => 'philips_hue#unregister'
    post '/synchronize' => 'philips_hue#synchronize'
    put '/lights/:id' => 'philips_hue#lights_update'
  end

  resources :device_scripts, defaults: { format: :json } do
    member do
      put :enable
      put :disable
    end
  end

  resources :buildings, defaults: { format: :json } do

    collection do
      get 'names', as: :names
    end

    member do
      get 'name'
    end

    resources :floors do

      collection do
        get 'names'
      end

      member do
        get 'name'
      end

      resources :rooms
    end
  end

  get '/floors' => 'floors#index', as: :floors, defaults: { format: :json }
  get '/rooms' => 'rooms#index', as: :rooms, defaults: { format: :json }

  # get '*any', via: :all, to: 'app#not_found'

end
