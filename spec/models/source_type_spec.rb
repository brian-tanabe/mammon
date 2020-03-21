require 'rails_helper'

RSpec.describe SourceType, type: :model do

	describe 'create' do

		context 'when the source type is valid' do

			it 'should be able to create a source type' do
				source_type = create(:source_type)

				# Verify against the persisted source type
				expect(SourceType.find(source_type.id).name).to eq(source_type.name)
			end

		end

		context 'when the source type is not valid' do

			it 'should not allow redundant names' do
				source_type = create(:source_type)

				another_source_type = build(:source_type, name: source_type.name)
				expect { another_source_type.save! }.to raise_error(ActiveRecord::RecordNotUnique)
			end

			it 'should not allow source types without users' do
				invalid_source_type = build(:source_type, user: nil)

				expect { invalid_source_type.save! }.to raise_error(ActiveRecord::RecordInvalid)
			end

		end

	end

	describe 'find' do

		it 'should be able to find all source types by user' do
			test_user = create(:user)
			some_other_user = create(:user)

			expected_source_types = create_list(:source_type, 5, user: test_user)
			create_list(:source_type, 5, user: some_other_user)

			expect(SourceType.where(user: test_user).all).to eq(expected_source_types)
		end

	end

end
