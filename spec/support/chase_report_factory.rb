require 'csv'
require 'securerandom'
require 'uri'

module ReportFactory

	def create_chase_report(transactions)

		# Generate a random filename
		filename = "#{SecureRandom.uuid}.csv"

		# Sort input transactions by transaction date.  The report is sorted from oldest to youngest
		transactions = transactions.sort_by(&:date)

		# Create the csv file
		CSV.open(filename, 'wb') do |csv|

			# Add the header
			csv << ['Transaction Date', 'Post Date', 'Description', 'Category', 'Type', 'Amount']

			# Loop through all transactions and add them to the CSV file
			transactions.each do |transaction|
				transaction_date = transaction.date.strftime("%Y/%m/%d")
				post_date = (transaction.date + ONE_DAY).strftime("%Y/%m/%d")
				# TODO: URL ESCAPE THIS NAME BUT IGNORE SPACES: EASTLAKE BAR &amp; GRILL
				description = transaction.name.upcase
				category = transaction.transaction_category
				type = transaction.transaction_type.capitalize
				amount = transaction.amount

				csv << [transaction_date, post_date, description, category, type, amount]
			end
		end

		# Return the filename.  The factory will open it
		filename
	end

	ONE_DAY = 1

end