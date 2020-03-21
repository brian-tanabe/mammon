require 'source_queries'

class SourcesController < ApplicationController
	before_action :authenticate_user!

	def index
		@sources = SourceQueries.new(current_user).all
	end

end
