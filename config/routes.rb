Rails.application.routes.draw do
	draw(:devise)
	draw(:home)
	draw(:import)
	draw(:source)
	draw(:source_type)

	# Default homepage
	root to: 'home#index'
end
