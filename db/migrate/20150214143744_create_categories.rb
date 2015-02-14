class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.text :name, null: false
      t.integer :posts_count, null: false, default: 0

      t.timestamps null: false

      t.index :name, unique: true
    end
  end
end
