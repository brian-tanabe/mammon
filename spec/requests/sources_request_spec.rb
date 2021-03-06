require 'rails_helper'

RSpec.describe "Sources", type: :request do

	describe 'GET /index' do

		context 'when not logged in' do

			it 'returns not authorized' do
				get '/sources/index'
				expect(response).to have_http_status(302)
			end

		end

		context 'when logged in' do

			it 'returns http success' do
				sign_in create(:user)

				get '/sources/index'
				expect(response).to have_http_status(:success)
			end

		end

	end

end
