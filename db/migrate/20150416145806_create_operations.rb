class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.integer :user_id
      t.string :operation
      t.text :encrypted_parameters
      t.string :nonce
      t.timestamps null: false
    end
  end
end
