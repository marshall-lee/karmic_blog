class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :title, null: false
      t.text :body
      t.references :category, index: true
      t.references :author, index: true
      t.integer :rating, null: false

      t.timestamps null: false
    end
    add_foreign_key :posts, :categories
    add_foreign_key :posts, :authors
  end
end
