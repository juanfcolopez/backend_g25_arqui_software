Rails.application.routes.draw do
  devise_for :users
  # root 'chats#index'
  
  # resources :chats do
  #    post 'messages', to: 'messages#create'
  # end
  namespace 'api' do
    namespace 'v1' do
      resources :chats
      resources :chats do
          post 'messages', to: 'messages#create'
      end
      devise_scope :user do
        post "sign_up", to: "registrations#create"
        post "sign_in", to: "sessions#create"
        get "manage_users", to: "admins#index"
        get "manage_users/:id", to: "admins#show"
        put "manage_users/:id", to: "admins#update"

      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # https://github.com/heartcombo/devise/issues/2840#issuecomment-342107399
  # https://github.com/heartcombo/devise/issues/2840#issuecomment-404026763
end
