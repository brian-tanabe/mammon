Rails.application.routes.draw do
	draw(:devise)
	draw(:home)

	# Default homepage
	root to: 'home#index'
end
