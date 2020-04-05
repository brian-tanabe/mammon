require 'csv'
require 'digest'

class ChaseVisaTransactionFactory

	def build_all(csv_file, user, transaction_source)

		# Sort all transactions by transaction date
		transaction_hashes = parse_csv(csv_file)

		# Add user and source information to each transaction hash
		add_user_id_source_id_and_timestamps_to_each_transaction_hash(transaction_hashes, user, transaction_source)

		# TODO: VALIDATE THE CORRECTNESS OF EACH TRANSACTION

		transaction_hashes
	end

	private

	def parse_csv(csv_file)
		csv_parser = CSV.read(csv_file, headers: true)

		# Sort by transaction_date.
		# This order matters since it dictates what the generated transaction_id is
		csv_parser = sort_csv_file_by_transaction_date(csv_parser)

		previous_month = {}

		transaction_hashes = []
		csv_parser.each_with_index do |row, transaction_index_in_file|
			# For now, we're ignoring the post_date
			transaction_date = Date.strptime(row[TRANSACTION_DATE], "%m/%d/%Y")
			post_date = Date.strptime(row[POST_DATE], "%m/%d/%Y")

			# Credit/Debit currency amount
			amount = row[AMOUNT]

			# Vendor properties
			description = row[DESCRIPTION]
			category = row[CATEGORY]

			# Sale/Credit/Adjustment:
			transaction_type = row[TYPE].downcase.to_s

			# Reset the month index counter if we've found a new month
			previous_month = update_current_month_index_hash(previous_month, transaction_date, transaction_index_in_file)

			# TransactionId
			transaction_id = generate_transaction_id(transaction_index_in_file - previous_month[:start_index], transaction_date, transaction_type, amount, description)

			# Create a transaction hash.  We're doing this so we can use ActiveRecord::upsert_all
			transaction_hashes << {
				name: description,
				# date: Date.strptime(transaction_date, "%m/%d/%Y"),
				date: transaction_date,
				transaction_type: Transaction.transaction_types[transaction_type],
				amount: amount,
				transaction_category: category,
				transaction_id: transaction_id
			}
		end

		transaction_hashes
	end

	def sort_csv_file_by_transaction_date(csv_parser)
		# Sort by transaction_date.
		# This order matters since it dictates what the generated transaction_id is
		csv_parser.sort do |lhs, rhs|
			Date.strptime(lhs[TRANSACTION_DATE], "%m/%d/%Y") <=> Date.strptime(rhs[TRANSACTION_DATE], "%m/%d/%Y")
		end
	end

	def update_current_month_index_hash(current_month_index_hash, transaction_date, transaction_index)
		current_date = current_month_index_hash[:current_month]

		if current_date.nil?
			# We're on the first index
			current_month_index_hash[:current_month] = transaction_date
			current_month_index_hash[:start_index] = transaction_index
		elsif current_date.year < transaction_date.year or current_date.month < transaction_date.month
			current_month_index_hash[:current_month] = transaction_date
			current_month_index_hash[:start_index] = transaction_index
		end

		current_month_index_hash
	end

	# TODO: TAKE IN A LIST OF TRANSACTION OBJECTS INSTEAD
	# TODO: MOVE TO ITS OWN CLASS
	def generate_transaction_id(record_index, transaction_date, transaction_type, transaction_amount, transaction_name)

		hash_string = {
			year: transaction_date.year,
			month: transaction_date.month,
			day: transaction_date.day,
			record_index: record_index,
			type: transaction_type,
			amount: transaction_amount,
			name: transaction_name
		}.to_s

		Digest::MD5.hexdigest(hash_string)
	end

	def add_user_id_source_id_and_timestamps_to_each_transaction_hash(transaction_hashes, user, source)
		now = Time.now

		transaction_hashes.each do |transaction|
			transaction[:user_id] = user.id
			transaction[:source_id] = source.id
			transaction[:created_at] = now
			transaction[:updated_at] = now
		end

		transaction_hashes
	end

	TRANSACTION_DATE = 'Transaction Date'
	POST_DATE = 'Post Date'
	DESCRIPTION = 'Description'
	CATEGORY = 'Category'
	TYPE = 'Type'
	AMOUNT = 'Amount'

end