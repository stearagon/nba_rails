Rails.application.routes.draw do
    devise_for :users, controllers: { sessions: 'api/sessions' }

    namespace :api do
        resources :players, only: :index
        resources :stat_lines, only: :index
        resources :users, only: :index
    end
end
