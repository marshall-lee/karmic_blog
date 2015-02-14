module ILike
  extend ActiveSupport::Concern

  module ClassMethods
    def ilike(field, query)
      where(arel_table[field].matches(query))
    end
  end
end
