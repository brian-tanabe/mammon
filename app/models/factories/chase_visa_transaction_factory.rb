require 'csv'

class ChaseVisaTransactionFactory


	def build_all(csv_file, user, transaction_source)
		csv_parser = CSV.read(csv_file, headers: true)

		transactions = []
		csv_parser.each do |row|

			# For now, we're ignoring the post_date
			transaction_date = row[TRANSACTION_DATE]
			post_date = row[POST_DATE]

			# Credit/Debit currency amount
			amount = row[AMOUNT]

			# Vendor properties
			description = row[DESCRIPTION]
			category = row[CATEGORY]

			# Sale/Credit/Adjustment:
			type = row[TYPE]

			transactions << Transaction.new(
				user: user,
				source: transaction_source,
				name: description,
				date: transaction_date,
				transaction_type: type,
				amount: amount,
				transaction_category: category
			)
		end

		transactions
	end

	private

	TRANSACTION_DATE = 'Transaction Date'
	POST_DATE = 'Post Date'
	DESCRIPTION = 'Description'
	CATEGORY = 'Category'
	TYPE = 'Type'
	AMOUNT = 'Amount'

end