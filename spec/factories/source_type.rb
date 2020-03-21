require 'faker'

FactoryBot.define do

	factory :source_type do
		association :user
		name { Faker::Name.name }
	end

end
