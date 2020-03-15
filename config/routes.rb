Rails.application.routes.draw do
	draw(:home)

	# Default homepage
    root to: 'home#index'
end
