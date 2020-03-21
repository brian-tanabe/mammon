require 'rails_helper'

RSpec.describe SourcesController, type: :controller do

	describe 'index' do

		context 'when logged in' do

			it 'should load sources for the user' do
				# Create a test user and a bunch of sources for it
				user = create(:user)
				sources = create_list(:source, 15, user: user)

				# Sign in the user
				sign_in user

				# Get the controller's index
				get :index

				# Verify that we've set the sources variable to all the sources we previously created
				expect(assigns(:sources)).to eq(sources)
			end

		end

		context 'when not logged in' do

			it 'should redirect to the login page' do
				# Create a test user and a bunch of sources for it
				user = create(:user)
				sources = create_list(:source, 15, user: user)

				# Get the controller's index
				get :index

				# Verify that the sources variable was not set
				expect(assigns(:sources)).to be_nil

				# Verify that we've been redirected to the login page
				expect(response).to redirect_to('/users/sign_in')
			end

		end

	end

end
