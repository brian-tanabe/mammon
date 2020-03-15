require 'faker'

FactoryBot.define do

	factory :user do
		name { Faker::Name.name }
		email { Faker::Internet.email }

		# 10 characters is greater than our minimum password length
		password { Faker::Lorem.characters(number: 10) }
	end

end
