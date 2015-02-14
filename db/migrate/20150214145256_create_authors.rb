class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.text :name, null: false
      t.integer :posts_count, null: false, default: 0
      t.integer :rating_numerator, null: false, default: 0
      t.integer :rating_denominator, null: false, default: 1

      t.timestamps null: false

      t.index :name, unique: true
    end
  end
end
