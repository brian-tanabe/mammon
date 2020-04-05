require 'source_queries'
require 'factories/factory_library'

class ImportController < ApplicationController
	before_action :authenticate_user!

	def index
		@sources = SourceQueries.new(current_user).all
	end

	def upload_transactions
		records = params[:records]
		source_id = params[:source_id]

		source = Source.find(source_id)
		transaction_factory = FactoryLibrary.new.find_factory(source)
		transactions = transaction_factory.build_all(records, current_user, source)

		Transaction.upsert_all(transactions)
	end

end
