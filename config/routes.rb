Rails.application.routes.draw do
	draw(:devise)
	draw(:home)
	draw(:source)

	# Default homepage
	root to: 'home#index'
end
