require 'rails_helper'
require 'support/chase_report_factory'

require 'factories/chase_visa_transaction_factory'

RSpec.describe ChaseVisaTransactionFactory, type: :factory do
	include ReportFactory

	describe 'build_all' do

		let(:filename) {
			"tmp/#{SecureRandom.uuid}.csv"
		}

		after(:each) do
			File.delete(filename)
		end

		it 'should be able to create a transaction' do
			# Test user and source
			user = create(:user)
			source = create(:source, user: user)

			# Test transactions
			input_transactions = build_list(:transaction, 1, user: user, source: source)

			# Create Chase CSV report
			create_chase_report(filename, input_transactions)

			output_transaction_list = ChaseVisaTransactionFactory.new.build_all(filename, user.id, source)

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
			create_chase_report(filename, input_transactions)

			output_transaction_list = ChaseVisaTransactionFactory.new.build_all(filename, user.id, source)

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
			create_chase_report(filename, input_transactions)

			output_transaction_list = ChaseVisaTransactionFactory.new.build_all(filename, user.id, source)

			# I've precomputed their IDs
			first_transaction.transaction_id = '3a104c21611bc13b7bd4e6ee32c5f239'
			second_transaction.transaction_id = '4005e09d50439a9c2d0f2a73cd9d4028'
			third_transaction.transaction_id = '76644245521bb1568338770d13c2f741'

			expect(output_transaction_list.pluck(:transaction_id)).to match_array([
																					  first_transaction.transaction_id,
																					  second_transaction.transaction_id,
																					  third_transaction.transaction_id
																				  ])
		end

		it 'should be able to generate transaction ids for reports that span multiple months' do
			# We need a predictable user and source ID:
			user = create(:user, id: 1)
			source = create(:source, user: user, id: 1)

			# Test transactions.  Their temporal order matters when generating their IDs
			month_one_first_transaction = build(
				:transaction,
				user: user,
				source: source,
				date: Date.new(2020, 3, 20),
				name: 'BRIAN LLC',
				transaction_type: :sale,
				amount: -123456.78
			)

			month_one_second_transaction = build(
				:transaction,
				user: user,
				source: source,
				date: Date.new(2020, 3, 21),
				name: 'AILISE LLC',
				transaction_type: :sale,
				amount: -5.75
			)

			month_one_third_transaction = build(
				:transaction,
				user: user,
				source: source,
				date: Date.new(2020, 3, 22),
				name: 'KRISTIN LLC',
				transaction_type: :sale,
				amount: -11.12
			)

			month_two_first_transaction = build(
				:transaction,
				user: user,
				source: source,
				date: Date.new(2020, 4, 20),
				name: 'BRIAN LLC',
				transaction_type: :sale,
				amount: -123456.78
			)

			month_two_second_transaction = build(
				:transaction,
				user: user,
				source: source,
				date: Date.new(2020, 4, 21),
				name: 'AILISE LLC',
				transaction_type: :sale,
				amount: -5.75
			)

			month_two_third_transaction = build(
				:transaction,
				user: user,
				source: source,
				date: Date.new(2020, 4, 22),
				name: 'KRISTIN LLC',
				transaction_type: :sale,
				amount: -11.12
			)

			# You'll notice they're loaded in a random order
			input_transactions = [
				month_two_second_transaction,
				month_two_first_transaction,
				month_one_third_transaction,
				month_one_first_transaction,
				month_two_third_transaction,
				month_one_second_transaction
			]

			# Create Chase CSV report
			create_chase_report(filename, input_transactions)

			output_transaction_list = ChaseVisaTransactionFactory.new.build_all(filename, user.id, source)

			# I've precomputed their IDs
			month_one_first_transaction.transaction_id = '3a104c21611bc13b7bd4e6ee32c5f239'
			month_one_second_transaction.transaction_id = '4005e09d50439a9c2d0f2a73cd9d4028'
			month_one_third_transaction.transaction_id = '76644245521bb1568338770d13c2f741'
			month_two_first_transaction.transaction_id = '9820dc336ed5e63248408ad7c5d19b2c'
			month_two_second_transaction.transaction_id = '7888599d5461c9533b317781a30a720a'
			month_two_third_transaction.transaction_id = '67f610b4c3e8aca8c4a996cddf8e738f'

			expect(output_transaction_list.pluck(:transaction_id)).to match_array([
																					  month_one_first_transaction.transaction_id,
																					  month_one_second_transaction.transaction_id,
																					  month_one_third_transaction.transaction_id,
																					  month_two_first_transaction.transaction_id,
																					  month_two_second_transaction.transaction_id,
																					  month_two_third_transaction.transaction_id
																				  ])
		end

		it 'should be able to generate transaction ids when there are more than one transaction on a day' do
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
				date: Date.new(2020, 3, 21),
				name: 'AILISE LLC',
				transaction_type: :sale,
				amount: -5.75
			)

			forth_transaction = build(
				:transaction,
				user: user,
				source: source,
				date: Date.new(2020, 3, 22),
				name: 'KRISTIN LLC',
				transaction_type: :sale,
				amount: -11.12
			)

			# You'll notice they're loaded in a random order
			input_transactions = [second_transaction, first_transaction, third_transaction, forth_transaction]

			# Create Chase CSV report
			create_chase_report(filename, input_transactions)

			output_transaction_list = ChaseVisaTransactionFactory.new.build_all(filename, user.id, source)

			# I've precomputed their IDs
			first_transaction.transaction_id = '3a104c21611bc13b7bd4e6ee32c5f239'
			second_transaction.transaction_id = '4005e09d50439a9c2d0f2a73cd9d4028'
			third_transaction.transaction_id = '8d765869badac9d71ce44f199f4642f6'
			forth_transaction.transaction_id = '8179b0abb92cf9f73acb8e26d2cc115d'

			expect(output_transaction_list.pluck(:transaction_id)).to match_array([
																					  first_transaction.transaction_id,
																					  second_transaction.transaction_id,
																					  third_transaction.transaction_id,
																					  forth_transaction.transaction_id
																				  ])
		end

	end

end