class AuthorsController < ApplicationController
  respond_to :json
  def autocomplete
    authors = Author.name_starting_with(params[:query])
    render json: {
      query: params[:query],
      suggestions: authors.limit(20).pluck(:name)
    }
  end
end
