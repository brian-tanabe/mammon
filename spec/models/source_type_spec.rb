require 'rails_helper'

RSpec.describe SourceType, type: :model do

	describe 'create' do

		it 'should be able to create a source type' do
			source_type = create(:source_type)
			source_type.save!

			# Verify against the persisted source type
			expect(SourceType.find(source_type.id).name).to eq(source_type.name)
		end

		it 'should not allow redundant names' do
			source_type = create(:source_type)
			source_type.save!

			another_source_type = build(:source_type, name: source_type.name)
			expect { another_source_type.save! }.to raise_error(ActiveRecord::RecordNotUnique)
		end

	end

end
