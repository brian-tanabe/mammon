require 'faker'

FactoryBot.define do

	factory :source_type do
		name { Faker::Name.name }
	end

end
