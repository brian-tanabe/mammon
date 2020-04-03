require 'csv'
require 'digest'

class ChaseVisaTransactionFactory

	def build_all(csv_file, user, transaction_source)

		# Sort all transactions by transaction date
		transactions_hash = parse_csv(csv_file)

		# Create the transaction objects
		transactions = []
		transactions_hash.each do |transaction|
			transactions << Transaction.new(
				# These are identical across transactions
				user_id: user,
				source: transaction_source,

				# These are unique to the transaction
				name: transaction[:name],
				date: transaction[:date],
				transaction_type: transaction[:transaction_type].downcase,
				amount: transaction[:amount],
				transaction_category: transaction[:transaction_category],

				transaction_id: generate_transaction_id(transaction, transactions_hash)
			)
		end

		transactions
	end

	protected

	private

	def parse_csv(csv_file)
		csv_parser = CSV.read(csv_file, headers: true)

		transactions_hash = []
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

			# Create a transaction hash.  We're doing this so we can generate transaction IDs later
			transactions_hash << {
				name: description,
				date: Date.parse(transaction_date),
				transaction_type: type,
				amount: amount,
				transaction_category: category
			}
		end

		# Sort all transactions by transaction date
		transactions_hash.sort_by! { |transaction| transaction[:date] }
	end

	# TODO: TAKE IN A LIST OF TRANSACTION OBJECTS INSTEAD
	# TODO: MOVE TO ITS OWN CLASS
	def generate_transaction_id(transaction_hash, transaction_list)

		# Get all transactions in the same month
		transactions_from_same_month = transaction_list.select do |potential_matching_transaction|
			potential_matching_date = potential_matching_transaction[:date]

			same_year = potential_matching_date.year.equal?(transaction_hash[:date].year)
			same_month = potential_matching_date.month.equal?(transaction_hash[:date].month)

			same_year && same_month
		end

		# Sort those transactions.  The sort order can't change or the generated hash will change!
		sorted_transactions_from_same_month = transactions_from_same_month.sort_by { |transaction|
			[
				transaction[:date],
				transaction[:name],
				transaction[:transaction_type],
				transaction[:amount]
			]
		}

		# Find the index of this transaction in the sorted array of transactions this month.  This will
		# become a seed to the hash to avoid duplicates if we buy something for the same price at the same
		# place on the same day
		record_index = sorted_transactions_from_same_month.find_index(transaction_hash)

		{
			year: transaction_hash[:date].year,
			month: transaction_hash[:date].month,
			day: transaction_hash[:date].day,
			record_index: record_index,
			type: transaction_hash[:transaction_type],
			amount: transaction_hash[:amount],
			name: transaction_hash[:name]
		}.hash.to_s

		hash_string = {
			year: transaction_hash[:date].year,
			month: transaction_hash[:date].month,
			day: transaction_hash[:date].day,
			record_index: record_index,
			type: transaction_hash[:transaction_type],
			amount: transaction_hash[:amount],
			name: transaction_hash[:name]
		}.to_s

		Digest::MD5.hexdigest(hash_string)
	end

	TRANSACTION_DATE = 'Transaction Date'
	POST_DATE = 'Post Date'
	DESCRIPTION = 'Description'
	CATEGORY = 'Category'
	TYPE = 'Type'
	AMOUNT = 'Amount'

end