Sembl::Application.routes.draw do
  namespace :admin, module: :admin, constraints: AdminConstraint do
    resources :things, except: [:show]

    root to: "home#show"
  end

  devise_for :users

  root to: "home#show"
end
