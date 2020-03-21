class AddUserReferenceToSourceTypes < ActiveRecord::Migration[6.0]

	def change
		add_reference :source_types, :user, null: false, foreign_key: true
	end

end
