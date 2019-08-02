class AddCompositeIndexToRates < ActiveRecord::Migration[5.0]
  def change
    add_index :rates, [:user_id, :rater_id], unique: true
  end
end
