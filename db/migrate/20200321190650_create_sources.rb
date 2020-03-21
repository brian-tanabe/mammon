class CreateSources < ActiveRecord::Migration[6.0]
	def change
		create_table :sources do |t|
			t.string :name
			t.references :user, null: false, foreign_key: true
			t.references :servicer, null: false, foreign_key: true

			t.timestamps
		end

		add_index :sources, [:name, :user_id, :servicer_id], unique: true
	end
end
