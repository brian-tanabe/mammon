class AddUserReferenceToSourceTypes < ActiveRecord::Migration[6.0]

	def change
		add_reference :source_types, :user, null: false, foreign_key: true

		add_index :source_types, [:name, :user_id], unique: true
	end

end
