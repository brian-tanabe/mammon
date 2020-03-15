require 'rails_helper'

RSpec.describe User, type: :model do

	describe 'create' do

		it 'should be able to save user name and email' do
			user = User.create!(name: 'Brian Tanabe', email: 'btanabe2@gmail.com', password: 'password')

			# Check the email from the persisted email
			persistedUser = User.find(user.id)
			expect(persistedUser.name).to eq('Brian Tanabe')
			expect(persistedUser.email).to eq('btanabe2@gmail.com')
		end

	end

end
