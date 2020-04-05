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

			output_transaction_list = ChaseVisaTransactionFactory.new.build_all(filename, user, source)

			test_transaction = output_transaction_list.first

			expect(test_transaction[:user_id]).to eq(user.id)
			expect(test_transaction[:source_id]).to eq(source.id)
			expect(test_transaction[:name]).to eq(input_transactions.first.name)
			expect(test_transaction[:date]).to eq(input_transactions.first.date)
			expect(test_transaction[:transaction_type]).to eq(Transaction.transaction_types[input_transactions.first.transaction_type])
			expect(test_transaction[:amount]).to eq(input_transactions.first.amount.to_s)
			expect(test_transaction[:transaction_category]).to eq(input_transactions.first.transaction_category)
		end

		it 'it should be able to generate transaction ids' do
			# We need a predictable user and source ID:
			user = create(:user, id: 1)
			source = create(:source, user: user, id: 1)

			# Test transactions.  Their temporal order matters when generating their IDs
			input_transactions = build_list(:transaction, 1, user: user, source: source, date: Date.new(2020, 3, 20), name: 'BRIAN LLC', transaction_type: :sale, amount: -123456.78)

			# Create Chase CSV report
			create_chase_report(filename, input_transactions)

			output_transaction_list = ChaseVisaTransactionFactory.new.build_all(filename, user, source)

			expect(output_transaction_list.length).to eq(1)

			test_transaction = output_transaction_list.first
			expect(test_transaction[:user_id]).to eq(user.id)
			expect(test_transaction[:source_id]).to eq(source.id)
			expect(test_transaction[:name]).to eq(input_transactions.first.name)
			expect(test_transaction[:date]).to eq(input_transactions.first.date)
			expect(test_transaction[:transaction_type]).to eq(Transaction.transaction_types[input_transactions.first.transaction_type])
			expect(test_transaction[:amount]).to eq(input_transactions.first.amount.to_s)
			expect(test_transaction[:transaction_category]).to eq(input_transactions.first.transaction_category)

			# This is an MD5 hash of:
			# {:year=>2020, :month=>3, :day=>20, :record_index=>0, :type=>"sale", :amount=>"-123456.78", :name=>"BRIAN LLC"}
			expect(test_transaction[:transaction_id]).to eq('3b748e37a2e1f340910c8fa8dda2b73b')
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

			output_transaction_list = ChaseVisaTransactionFactory.new.build_all(filename, user, source)

			# I've precomputed their IDs
			# {:year=>2020, :month=>3, :day=>20, :record_index=>0, :type=>"sale", :amount=>"-123456.78", :name=>"BRIAN LLC"}
			first_transaction.transaction_id = '3b748e37a2e1f340910c8fa8dda2b73b'
			# {:year=>2020, :month=>3, :day=>21, :record_index=>1, :type=>"sale", :amount=>"-5.75", :name=>"AILISE LLC"}
			second_transaction.transaction_id = 'd8663fe19aa9fd770312680a319d78ff'
			# {:year=>2020, :month=>3, :day=>22, :record_index=>2, :type=>"sale", :amount=>"-11.12", :name=>"KRISTIN LLC"}
			third_transaction.transaction_id = 'cc73b80310f5e648b0c879c3d5fac0f7'

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

			output_transaction_list = ChaseVisaTransactionFactory.new.build_all(filename, user, source)

			# I've precomputed their IDs
			# {:year=>2020, :month=>3, :day=>20, :record_index=>0, :type=>"sale", :amount=>"-123456.78", :name=>"BRIAN LLC"}
			month_one_first_transaction.transaction_id = '3b748e37a2e1f340910c8fa8dda2b73b'
			# {:year=>2020, :month=>3, :day=>21, :record_index=>1, :type=>"sale", :amount=>"-5.75", :name=>"AILISE LLC"}
			month_one_second_transaction.transaction_id = 'd8663fe19aa9fd770312680a319d78ff'
			# {:year=>2020, :month=>3, :day=>22, :record_index=>2, :type=>"sale", :amount=>"-11.12", :name=>"KRISTIN LLC"}
			month_one_third_transaction.transaction_id = 'cc73b80310f5e648b0c879c3d5fac0f7'
			# {:year=>2020, :month=>4, :day=>20, :record_index=>0, :type=>"sale", :amount=>"-123456.78", :name=>"BRIAN LLC"}
			month_two_first_transaction.transaction_id = '02f8763582106edc357bf14f29f6f220'
			# {:year=>2020, :month=>4, :day=>21, :record_index=>1, :type=>"sale", :amount=>"-5.75", :name=>"AILISE LLC"}
			month_two_second_transaction.transaction_id = 'df3753dc860ae8fd23849384fcfc9d3e'
			# {:year=>2020, :month=>4, :day=>22, :record_index=>2, :type=>"sale", :amount=>"-11.12", :name=>"KRISTIN LLC"}
			month_two_third_transaction.transaction_id = '1c1bd444454a856034cd41189c8c22d8'

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

			output_transaction_list = ChaseVisaTransactionFactory.new.build_all(filename, user, source)

			# I've precomputed their IDs
			# {:year=>2020, :month=>3, :day=>20, :record_index=>0, :type=>"sale", :amount=>"-123456.78", :name=>"BRIAN LLC"}
			first_transaction.transaction_id = '3b748e37a2e1f340910c8fa8dda2b73b'
			# {:year=>2020, :month=>3, :day=>21, :record_index=>1, :type=>"sale", :amount=>"-5.75", :name=>"AILISE LLC"}
			second_transaction.transaction_id = 'd8663fe19aa9fd770312680a319d78ff'
			# {:year=>2020, :month=>3, :day=>21, :record_index=>2, :type=>"sale", :amount=>"-5.75", :name=>"AILISE LLC"}
			third_transaction.transaction_id = 'dd5e3e22b43410006ca2a03f54d962b2'
			# {:year=>2020, :month=>3, :day=>22, :record_index=>3, :type=>"sale", :amount=>"-11.12", :name=>"KRISTIN LLC"}
			forth_transaction.transaction_id = '8101915e04d2c3bd5c59097edfd00cb7'

			expect(output_transaction_list.pluck(:transaction_id)).to match_array([
																					  first_transaction.transaction_id,
																					  second_transaction.transaction_id,
																					  third_transaction.transaction_id,
																					  forth_transaction.transaction_id
																				  ])
		end

	end

end