class CategoriesController < ApplicationController
  before_action :authorize_request, except: [ :index, :show ] # if those are public

  load_and_authorize_resource except: [ :index, :show ]

  def create
    @category = Category.new(category_params)
    if @category.save
      render json: @category, status: :created
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def index
    @categories = Category.all
    render json: @categories
  end

  def show
    render json: @category
  end

  def update
    if @category.update(category_params)
      render json: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    head :no_content
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
