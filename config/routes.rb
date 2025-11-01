Rails.application.routes.draw do
  # Devise (login, signup, logout etc)
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  # Página inicial
  root "pages#home"

  # Painel admin (usando Administrate)
  namespace :admin do
    resources :users
    root to: "users#index"  # Página inicial do painel admin
  end

  # Outras páginas simples (se existirem)
  get "pages/users"
  get "pages/admin"

  # Health check (padrão Rails 8)
  get "up" => "rails/health#show", as: :rails_health_check
end
