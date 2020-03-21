require 'faker'

FactoryBot.define do

	factory :servicer do
		association :user
		association :source_type
		name { Faker::Name.name }
	end

end
