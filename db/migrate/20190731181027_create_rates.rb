class CreateRates < ActiveRecord::Migration[5.0]
  def change
    create_table :rates do |t|
      t.integer :user_id, foreign_key: true, index: true
      t.integer :rater_id, foreign_key: true, index: true
      t.boolean :value
      t.index :value
      t.timestamps
    end
  end
end
