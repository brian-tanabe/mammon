require 'rails_helper'
require 'source_queries'

RSpec.describe SourceQueries, type: :query do

	describe 'sources' do

		it 'should be able to loop through sources' do
			user = create(:user)
			sources = create_list(:source, 5, user: user)

			SourceQueries.new(user).sources.each do |source|
				expect(sources).to include(source)
			end
		end

		it 'should not include sources from other users' do
			user = create(:user)
			another_user = create(:user)

			sources = create_list(:source, 5, user: user)
			create_list(:source, 5, user: another_user)

			expect(sources).to eq(SourceQueries.new(user).all.to_a)
		end

	end

end