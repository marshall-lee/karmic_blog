class Post < ActiveRecord::Base
  belongs_to :category, counter_cache: true
  belongs_to :author

  validates_presence_of :title
  validates_presence_of :rating
  validates_presence_of :category
  validates_presence_of :author
  validates :rating, inclusion: { in: 0..5 }

  attr_writer :author_name
  def author_name
    @author_name ||= if author then author.name end
  end

  attr_writer :category_name
  def category_name
    @category_name ||= if category then category.name end
  end

  before_validation(on: [:create, :update]) do |post|
    post.rating ||= rand(0..5)
    post.author = Author.find_or_create_unique_by(name: author_name) if author_name.present?
    post.category = Category.find_or_create_unique_by(name: category_name) if category_name.present?
  end

  after_create do |post|
    author.on_post_add(post)
  end

  after_destroy do |post|
    author.on_post_remove(post)
  end

  default_scope -> { includes(:category, :author) }
  scope :order_by_rating, -> { order rating: :desc }
  scope :order_by_author_rating, -> { eager_load(:author).merge(Author.order_by_rating) }
  scope :top10, -> { order_by_rating.limit(10) }
  scope :with_best_authors, -> { eager_load(:author).merge(Author.with_highest_rating) }
  scope :created_on, -> (date) { where created_at: date.beginning_of_day..date.end_of_day  }
end
