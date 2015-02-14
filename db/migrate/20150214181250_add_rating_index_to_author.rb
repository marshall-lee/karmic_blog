class AddRatingIndexToAuthor < ActiveRecord::Migration
  def change
    add_index :authors, name: 'index_authors_on_rating', expression: Author::RatingSQL
  end
end
