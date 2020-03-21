require 'faker'

FactoryBot.define do

	factory :source do
		association :user
		association :servicer
		name { Faker::Name.name }
	end

end
