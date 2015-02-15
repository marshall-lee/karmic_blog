class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  respond_to :html

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all

    filters = params[:filters]

    if filters.present?
      if filters[:author_name].present?
        @posts = @posts.where authors: { name: filters[:author_name] }
      end

      if filters[:category_name].present?
        @posts = @posts.where categories: { name: filters[:category_name] }
      end

      if filters[:created_on].present?
        @posts = @posts.created_on(filters[:created_on].to_date)
      end

      if filters[:rating].present?
        @posts = @posts.where rating: filters[:rating]
      end

      if filters[:rating_between].present?
        from = filters[:rating_between][:from]
        to = filters[:rating_between][:to]
        if from.present? && to.present?
          @posts = @posts.where(rating: from..to)
        end
      end

      if filters[:order_by_author_rating] == "1"
        @posts = @posts.order_by_author_rating
      end
    end

    @posts = @posts.top10

    if params[:partial].blank?
      respond_with @posts
    else
      render @posts
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.save
    respond_with @post
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    @post.update(post_params)
    respond_with @post
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_with @post
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, :author_name, :category_name, :created_at)
    end
end
