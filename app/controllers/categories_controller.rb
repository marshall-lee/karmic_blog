class CategoriesController < ApplicationController
  respond_to :json
  def autocomplete
    categories = Category.name_starting_with(params[:query])
    render json: {
      query: params[:query],
      suggestions: categories.limit(20).pluck(:name)
    }
  end
end
