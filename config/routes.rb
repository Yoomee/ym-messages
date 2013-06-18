Rails.application.routes.draw do

  resources :messages, :only => [:new, :create]

  resources :users, :only => [] do
    resources :messages, :only => [:new] do
      collection do
        put 'update_settings'
      end
    end
  end
  
  resources :message_threads, :only => [:index, :show], :path => 'messages' do 
    collection do
      match 'all'
    end
  end
  

end
