class Author < ActiveRecord::Base
  include FindOrCreateUniqueBy
  include ILike
  has_many :posts, dependent: :destroy

  RatingSQL = "div(cast(rating_numerator as decimal), rating_denominator)"
  MaxRatingSQL = "max(#{RatingSQL})"


  def on_post_add(post)
    with_lock do
      self.posts_count += 1
      self.rating = (rating * (self.posts_count - 1) + post.rating) / posts_count
      save
    end
  end

  def on_post_remove(post)
    with_lock do
      self.posts_count -= 1
      if posts_count > 0
        self.rating = (rating * (posts_count + 1) - post.rating) / posts_count
      else
        self.rating = Rational(0)
      end
      save
    end
  end

  def rating
    @rating ||= Rational(rating_numerator, rating_denominator)
  end

  scope :name_starting_with, -> (query) { ilike :name, "#{query}%" }
  scope :with_rating, -> { select :*, "#{RatingSQL} as author_rating" }
  scope :order_by_rating, -> { with_rating.order "author_rating DESC" }

  def self.highest_rating
    maximum(RatingSQL)
  end

  def self.with_highest_rating
    where("#{RatingSQL} = (#{select(MaxRatingSQL).to_sql})")
  end

  protected
    def rating=(rational)
      self.rating_numerator = rational.numerator
      self.rating_denominator = rational.denominator
      @rating = rational
    end
end
