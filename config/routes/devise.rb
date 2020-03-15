devise_for :users, controllers: { registrations: "registrations" }

devise_scope :user do
	get 'login', to: 'devise/sessions#new'
	get 'register', to: 'devise/registrations#new'
	delete 'logout', to: 'devise/sessions#destroy'
end