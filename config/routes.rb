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
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
