class CreateServicers < ActiveRecord::Migration[6.0]
  def change
    create_table :servicers do |t|
      t.string :name
      t.references :source_type, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :servicers, :name, unique: true
  end
end
