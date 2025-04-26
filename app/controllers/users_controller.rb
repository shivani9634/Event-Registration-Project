class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_user, only: [ :show, :update, :destroy ]

  # GET /users
  def index
    users = User.all
    render json: users
  end

  # GET /users/:id
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: { message: "User created successfully", user: @user }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /users/:id
  def update
    if @user.update(user_params)
      render json: { message: "User updated successfully", user: @user }
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
    render json: { message: "User deleted successfully" }
  end

  private

  # Set the user based on the id from params for the show, update, and destroy actions
  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  # Strong parameters for user
  def user_params
    params.require(:user).permit(:name, :surname, :password, :phone_number, :email_id, :role_id)
  end
end
