require 'chase_visa_transaction_factory'

class FactoryLibrary

	def find_factory(source)
		ChaseVisaTransactionFactory.new
	end

end