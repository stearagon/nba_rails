Rails.application.routes.draw do
  namespace :api do
    resources :players, only: :index
    resources :stat_lines, only: :index
  end
end
