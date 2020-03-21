require 'rails_helper'

RSpec.describe Source, type: :model do

	describe 'create' do

		context 'when source is valid' do

			it 'should be able to create a source' do
				user = create(:user)
				servicer = create(:servicer, user: user)

				source = create(:source, user: user, servicer: servicer)

				expect(Source.find(source.id)).to eq(source)
			end

			it 'should allow duplicate names from different services' do
				user = create(:user)
				servicer = create(:servicer, user: user)

				source = create(:source, user: user, servicer: servicer)
				another_source = create(:source, user: user, name: source.name)

				expect(source.name).to eq(another_source.name)
				expect(Source.find(another_source.id).name).to eq(another_source.name)
			end

			it 'should allow duplicate names from different users' do
				source = create(:source)
				another_source = create(:source, name: source.name)

				expect(source.name).to eq(another_source.name)
				expect(Source.find(another_source.id).name).to eq(another_source.name)
			end

		end

		context 'when source is not valid' do

			it 'should not allow duplicate names' do
				user = create(:user)
				servicer = create(:servicer, user: user)

				source = create(:source, user: user, servicer: servicer)
				invalid_source = build(:source, user: user, servicer: servicer, name: source.name)

				expect { invalid_source.save! }.to raise_exception(ActiveRecord::RecordNotUnique)
			end

		end

	end

end
