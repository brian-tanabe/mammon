require 'servicer_queries'
require 'source_queries'
require 'source_type_queries'

class SourcesController < ApplicationController
	before_action :authenticate_user!

	def index
		user = current_user

		@new_source_type = SourceType.new(user: user)
		@new_servicer = Servicer.new(user: user)
		@new_source = Source.new(user: user)

		@source_types = SourceTypeQueries.new(user).all
		@servicers = ServicerQueries.new(user).all
		@sources = SourceQueries.new(user).all
	end

	def new_source_type
		user = current_user
		@source_type = SourceType.new(new_source_type_params)
		@source_type.user = user

		if @source_type.save
			@source_types = SourceTypeQueries.new(user).all
			redirect_to action: :index
		else
			render json: @source_type.errors, status: :unprocessable_entity
		end
	end

	def new_source_type_params
		params.require(:source_type).permit(:name)
	end

end
