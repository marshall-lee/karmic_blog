class Category < ActiveRecord::Base
  include FindOrCreateUniqueBy
  include ILike

  has_many :posts, dependent: :nullify

  scope :name_starting_with, -> (query) { ilike :name, "#{query}%" }
end
