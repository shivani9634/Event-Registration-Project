class CategoriesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_category, only: [ :show, :update, :destroy ]

  # GET /categories
  def index
    categories = Category.all
    render json: categories
  end

  # GET /categories/:id
  def show
    render json: @category
  end

  # POST /categories
  def create
    @category = Category.new(category_params)
    if @category.save
      render json: { message: "Category created successfully", category: @category }, status: :created
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /categories/:id
  def update
    if @category.update(category_params)
      render json: { message: "Category updated successfully", category: @category }
    else
      render json: { error: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /categories/:id
  def destroy
    @category.destroy
    render json: { message: "Category deleted successfully" }
  end

  private

  # Set the category based on the id from params for the show, update, and destroy actions
  def set_category
    @category = Category.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Category not found" }, status: :not_found
  end

  # Strong parameters for category
  def category_params
    params.require(:category).permit(:name, :type) # Ensure that :type is permitted if you want it
  end
end
