require 'rails_helper'

RSpec.describe Servicer, type: :model do

	describe 'create' do

		context 'when the servicer is valid' do

			it 'should be able to create a servicer' do
				servicer = create(:servicer)

				expect(Servicer.find(servicer.id).name).to eq(servicer.name)
			end

		end

		context 'when the servicer is not valid' do

			it 'should not allow redundant names' do
				servicer = create(:servicer)

				expect(Servicer.find(servicer.id).name).to eq(servicer.name)

				invalid_servicer = build(:servicer, name: servicer.name)
				expect { invalid_servicer.save! }.to raise_error(ActiveRecord::RecordNotUnique)
			end

			it 'should not allow services without users' do
				invalid_servicer = build(:servicer, user: nil)
				expect { invalid_servicer.save! }.to raise_error(ActiveRecord::RecordInvalid)
			end

			it 'should not allow services without source types' do
				invalid_servicer = build(:servicer, source_type: nil)
				expect { invalid_servicer.save! }.to raise_error(ActiveRecord::RecordInvalid)
			end

		end

	end

end



