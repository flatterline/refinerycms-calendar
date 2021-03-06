Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :calendar do
    get 'events/archive' => 'events#archive'
    resources :events, only: [:index, :show] do
      resources :attendees, only: [:new, :create], path: :register do
        collection do
          get :thanks
        end
      end

      resources :messages, only: [:new, :create]
    end
  end

  # Admin routes
  namespace :calendar, :path => '' do
    namespace :admin, :path => 'refinery/calendar' do
      resources :events do
        resources :attendees, only: [:index]
        collection do
          post :update_positions
          get :upcoming
        end
      end
    end
  end

end
