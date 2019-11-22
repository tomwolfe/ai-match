class CreatePredictions < ActiveRecord::Migration[6.0]
  def change
    create_table :predictions do |t|
      t.integer :user_id, foreign_key: true, index: true, null: false
      t.integer :predictor_id, foreign_key: true, index: true, null: false
      t.float :value
      t.index :value
      t.timestamps
    end
    add_index :predictions, [:user_id, :predictor_id], unique: true
  end
end
