class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.integer :age
      t.integer :height
      t.integer :weight
      t.string :orientation
      t.string :looking_for
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
