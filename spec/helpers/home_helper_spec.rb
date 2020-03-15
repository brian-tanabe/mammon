require 'rails_helper'

RSpec.describe HomeHelper, type: :helper do

	describe 'links' do

		context 'when a user is logged in' do

			# TODO: FIGURE OUT HOW TO CALL THE DEVISE HELPER METHODS FROM TESTS
			xit 'should be able to return the dropdown' do
				sign_in FactoryBot.create(:user)

				expect(links).to eq('home/partials/nav/dropdown')
			end

		end

		context 'when no users are logged in' do

			# TODO: FIGURE OUT HOW TO CALL THE DEVISE HELPER METHODS FROM TESTS
			xit 'should be able to return auth links' do
				expect(links).to eq('home/partials/nav/auth_links')
			end

		end

	end

end
