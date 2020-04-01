require 'rails_helper'
require 'support/chase_report_factory'

require 'factories/chase_visa_transaction_factory'

RSpec.describe ChaseVisaTransactionFactory, type: :factory do
	include ReportFactory

	describe 'build_all' do

		it 'should be able to create a transaction' do
			# Test user and source
			user = create(:user)
			source = create(:source, user: user)

			# Test transactions
			input_transactions = build_list(:transaction, 1, user: user, source: source)

			# Create Chase CSV report
			report_filename = create_chase_report(input_transactions)

			output_transaction_list = ChaseVisaTransactionFactory.new.build_all(report_filename, user.id, source)

			expect(output_transaction_list.length).to eq(1)

			test_transaction = output_transaction_list.first
			expect(test_transaction.user).to eq(user)
			expect(test_transaction.source).to eq(source)
			expect(test_transaction.name).to eq(input_transactions.first.name)
			expect(test_transaction.date).to eq(input_transactions.first.date)
			expect(test_transaction.transaction_type).to eq(input_transactions.first.transaction_type)
			expect(test_transaction.amount).to eq(input_transactions.first.amount)
			expect(test_transaction.transaction_category).to eq(input_transactions.first.transaction_category)
		end

		it 'it should be able to generate transaction ids' do
			# We need a predictable user and source ID:
			user = create(:user, id: 1)
			source = create(:source, user: user, id: 1)

			# Test transactions.  Their temporal order matters when generating their IDs
			input_transactions = build_list(:transaction, 1, user: user, source: source, date: Date.new(2020, 3, 20), name: 'BRIAN LLC', transaction_type: :sale, amount: -123456.78)

			# Create Chase CSV report
			report_filename = create_chase_report(input_transactions)

			output_transaction_list = ChaseVisaTransactionFactory.new.build_all(report_filename, user.id, source)

			expect(output_transaction_list.length).to eq(1)

			test_transaction = output_transaction_list.first
			expect(test_transaction.user).to eq(user)
			expect(test_transaction.source).to eq(source)
			expect(test_transaction.name).to eq(input_transactions.first.name)
			expect(test_transaction.date).to eq(input_transactions.first.date)
			expect(test_transaction.transaction_type).to eq(input_transactions.first.transaction_type)
			expect(test_transaction.amount).to eq(input_transactions.first.amount)
			expect(test_transaction.transaction_category).to eq(input_transactions.first.transaction_category)

			# This is an MD5 hash
			expect(test_transaction.transaction_id).to eq('3a104c21611bc13b7bd4e6ee32c5f239')
		end

		it 'should be able to generate transactionIds when there is more than one transaction in a month' do
			# We need a predictable user and source ID:
			user = create(:user, id: 1)
			source = create(:source, user: user, id: 1)

			# Test transactions.  Their temporal order matters when generating their IDs
			first_transaction = build(
				:transaction,
				user: user,
				source: source,
				date: Date.new(2020, 3, 20),
				name: 'BRIAN LLC',
				transaction_type: :sale,
				amount: -123456.78
			)

			second_transaction = build(
				:transaction,
				user: user,
				source: source,
				date: Date.new(2020, 3, 21),
				name: 'AILISE LLC',
				transaction_type: :sale,
				amount: -5.75
			)

			third_transaction = build(
				:transaction,
				user: user,
				source: source,
				date: Date.new(2020, 3, 22),
				name: 'KRISTIN LLC',
				transaction_type: :sale,
				amount: -11.12
			)

			# You'll notice they're loaded in a random order
			input_transactions = [second_transaction, first_transaction, third_transaction]

			# Create Chase CSV report
			report_filename = create_chase_report(input_transactions)

			output_transaction_list = ChaseVisaTransactionFactory.new.build_all(report_filename, user.id, source)

			# I've precomputed their IDs
			first_transaction.transaction_id = '3a104c21611bc13b7bd4e6ee32c5f239'
			second_transaction.transaction_id = '4005e09d50439a9c2d0f2a73cd9d4028'
			third_transaction.transaction_id = '76644245521bb1568338770d13c2f741'

			expect(output_transaction_list.pluck(&:transaction_id)).to contain_exactly(
																		   first_transaction.transaction_id,
																		   second_transaction.transaction_id,
																		   third_transaction.transaction_id
																	   )
		end

		xit 'it should be able to generate transaction ids for reports that span multiple months' do

		end

		xit 'should be able to generate transaction ids when there are more than one transaction on a day' do

		end

	end

end