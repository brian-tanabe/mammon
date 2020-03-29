class CreateTransactions < ActiveRecord::Migration[6.0]

	def change
		create_table :transactions do |t|
			t.references :user, null: false, foreign_key: true
			t.references :source, null: false, foreign_key: true
			t.string :name
			t.date :date
			t.integer :transaction_type, null: false
			t.decimal :amount
			t.string :transaction_category
			t.string :transaction_id, null: false

			t.timestamps
		end

		add_index :transactions, :transaction_id, unique: true
	end

end
