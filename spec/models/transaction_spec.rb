require 'rails_helper'

RSpec.describe Transaction, type: :model do

	describe 'create' do

		context 'when transaction is valid' do

			it 'should be able to create a transaction' do
				transaction = create(:transaction)
				expect(Transaction.find(transaction.id)).to eq(transaction)
			end

			it 'should be able to create multiple transactions with the same name' do
				transaction = create(:transaction)
				another_transaction = build(:transaction)

				another_transaction.name = transaction.name
				another_transaction.save!

				expect(Transaction.find(another_transaction.id).name).to eq(transaction.name)
			end

			it 'should allow all valid transactions' do
				transaction = build(:transaction)

				# Sale
				transaction.transaction_type = :sale
				transaction.save!
				expect(Transaction.find(transaction.id).transaction_type).to eq(:sale.to_s)

				# Return
				transaction.transaction_type = :return
				transaction.save!
				expect(Transaction.find(transaction.id).transaction_type).to eq(:return.to_s)

				# Payment
				transaction.transaction_type = :payment
				transaction.save!
				expect(Transaction.find(transaction.id).transaction_type).to eq(:payment.to_s)

				# Fee
				transaction.transaction_type = :fee
				transaction.save!
				expect(Transaction.find(transaction.id).transaction_type).to eq(:fee.to_s)

				# Adjustment
				transaction.transaction_type = :adjustment
				transaction.save!
				expect(Transaction.find(transaction.id).transaction_type).to eq(:adjustment.to_s)
			end

		end

		context 'when transaction is not valid' do

			it 'should reject attempts to create a transaction without a valid type' do
				invalid_transaction = build(:transaction)
				expect { invalid_transaction.transaction_type = :not_valid }.to raise_error(ArgumentError)
			end

			it 'should reject attempts to create a transaction without a user' do
				invalid_transaction = build(:transaction, user: nil)
				expect { invalid_transaction.save! }.to raise_error(ActiveRecord::RecordInvalid)
			end

			it 'should reject attempts to create a transaction without a source' do
				invalid_transaction = build(:transaction, source: nil)
				expect { invalid_transaction.save! }.to raise_error(ActiveRecord::RecordInvalid)
			end

			it 'should reject attempts to create a transaction without a transaction type' do
				invalid_transaction = build(:transaction, transaction_type: nil)
				expect { invalid_transaction.save! }.to raise_error(ActiveRecord::NotNullViolation)
			end

			it 'should reject attempts to re-use transaction ids' do
				transaction = create(:transaction)
				duplicate_transaction = build(:transaction, transaction_id: transaction.transaction_id)

				expect { duplicate_transaction.save! }.to raise_error(ActiveRecord::RecordNotUnique)
			end

			# We currently do not reject empty names
			xit 'should reject attempts to create a transaction without a name' do
				invalid_transaction = build(:transaction, name: nil)
				expect { invalid_transaction.save! }.to raise_error(ActiveRecord::RecordInvalid)
			end

			# We currently do not reject empty dates
			xit 'should reject attempts to create a transaction without a date' do
				invalid_transaction = build(:transaction, date: nil)
				expect { invalid_transaction.save! }.to raise_error(ActiveRecord::RecordInvalid)
			end

			# We currently do not reject empty amounts
			xit 'should reject attempts to create a transaction without an amount' do
				invalid_transaction = build(:transaction, amount: nil)
				expect { invalid_transaction.save! }.to raise_error(ActiveRecord::RecordInvalid)
			end

			# We currently do not reject empty transaction_categories
			xit 'should reject attempts to create a transaction without a transaction category' do
				invalid_transaction = build(:transaction, transaction_category: nil)
				expect { invalid_transaction.save! }.to raise_error(ActiveRecord::RecordInvalid)
			end

		end

	end
end
