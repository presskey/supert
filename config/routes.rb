Suppert::Application.routes.draw do

  devise_for :members

  resources :tickets, except: :index

  namespace :staff do
    resources :tickets, only: :show do
      collection do
        %w/unassigned open onhold closed/.each { |action| get action }
        post :search
      end
      put 'take_ownership', on: :member
      resources :replies
    end

    root to: 'tickets#unassigned'
  end

  root to: 'tickets#new'
end
