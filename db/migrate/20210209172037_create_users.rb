class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, presence: true, length: { maximum: 200 }, unique: true
      t.string :phone_number, presence: true, length: { maximum: 200 }, unique: true
      t.string :full_name, length: { maximum: 200 }
      t.string :password, length: { maximum: 100 }
      t.string :key, length: { maximum: 100 }, unique: true
      t.string :account_key, length: { maximum: 100 }
      t.string :metadata, length: { maximum: 2000 }

      t.timestamps
    end
    
    add_index :users, :email, unique: true
    add_index :users, :phone_number, unique: true
  end
end
