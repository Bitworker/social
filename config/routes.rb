# encoding: UTF-8
SN::Application.routes.draw do
  # Ermöglicht folgende URL-Struktur => /blogs/1/posts/99
  resources :blogs do
		resources :posts
	end

  # index aus der URL entfernen
 	match 'user' => 'user#index', :as => 'hub'
   
  # Usernamen URL
  match 'profile/:screen_name' => "profile#show", :as => :profile

 	# Root / Startseite 
 	match '' => 'site#index', :id => nil
  root :to => "Site#index"

  # Standardroute – niedrigste Priorität
 	match ':controller(/:action(/:id(.:format)))' 
end
