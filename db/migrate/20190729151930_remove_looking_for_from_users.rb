class RemoveLookingForFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :looking_for, :string
  end
end
