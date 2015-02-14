module FindOrCreateUniqueBy
  extend ActiveSupport::Concern

  module ClassMethods
    def find_or_create_unique_by(*args)
      first_try = true
      transaction(requires_new: true) do
        find_or_create_by(*args)
      end
    rescue ActiveRecord::RecordNotUnique
      if first_try
        first_try = false
        retry
      else
        raise
      end
    end
  end
end
