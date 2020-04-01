require 'faker'

FactoryBot.define do

	factory :transaction do
		association :user
		association :source
		name { Faker::Company.name.upcase }
		date { Faker::Date.between_except(from: 1.year.ago, to: Date.today, excepted: Date.today) }
		transaction_type { :sale }
		amount { -1 * Faker::Number.decimal(l_digits: 2) }
		transaction_category { Faker::Commerce.department }
		transaction_id { SecureRandom.uuid }
	end

end