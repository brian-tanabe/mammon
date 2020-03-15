require 'rails_helper'

RSpec.describe HomeHelper, type: :helper do

	describe 'links' do

		it 'should be able to return auth links' do
			expect(links).to eq('home/partials/nav/auth_links')
		end

	end

end
