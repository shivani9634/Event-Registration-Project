class CategoriesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_category, only: [ :show, :update ]

  # create
  def create
    @category = Category.new(category_params)
    if @category.save
      render json: @category, status: :created
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end
  # Get
  def index
    @categories = Category.all
    render json: @categories
  end


  def show
    render json: @category
  end

  # update
  def update
    if @category.update(category_params)
      render json: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # DELETE
  def destroy
    @category.destroy
    head :no_content
  end

  private

  # Define the 'set_category' method to find the category
  def set_category
    @category = Category.find(params[:id])
  end

  # params
  def category_params
    params.require(:category).permit(:name)
  end
end
