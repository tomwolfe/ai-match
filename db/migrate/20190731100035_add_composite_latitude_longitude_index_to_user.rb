class AddCompositeLatitudeLongitudeIndexToUser < ActiveRecord::Migration[5.0]
  def change
    add_index :users, [:latitude, :longitude]
  end
end
