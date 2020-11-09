Rails.application.routes.draw do
  devise_for :users
  # root 'chats#index'
  
  # resources :chats do
  #    post 'messages', to: 'messages#create'
  # end
  namespace 'api' do
    namespace 'v1' do
      get 'member-requests', to: 'members#index'
      resources :members do
        post 'validate', to: 'members#validate_request'
      end
      resources :chats
      resources :chats do
          post 'messages', to: 'messages#create'
          post 'associate', to: 'chats#associate'
          put 'change_private', to: 'chats#change_private'
      end
      devise_scope :user do
        post "sign_up", to: "registrations#create"
        post "sign_in", to: "sessions#create"

        # admin crud: manage users
        get "manage_users", to: "admins#index"
        get "manage_users/:id", to: "admins#show"
        put "manage_users/:id", to: "admins#update"

        # admin crud: manage chats
        get "manage_chats", to: "admins#index_chats"
        get "manage_chats/:id", to: "admins#show_chat"
        put "manage_chats/:id", to: "admins#update_chat"

        # admin crud: manage messages
        put "manage_messages/:id", to: "admins#censor_message"


      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # https://github.com/heartcombo/devise/issues/2840#issuecomment-342107399
  # https://github.com/heartcombo/devise/issues/2840#issuecomment-404026763
end
