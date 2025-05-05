class RolesController < ApplicationController
  load_and_authorize_resource

  def create
    @role = Role.new(role_params)
    if @role.save
      render json: @role, status: :created
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  def index
    @roles = Role.all
    render json: @roles
  end

  def show
    @role = Role.find(params[:id])
    render json: @role
  end

  def update
    @role = Role.find(params[:id])
    if @role.update(role_params)
      render json: @role
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @role = Role.find(params[:id])
    @role.destroy
    render json: { message: "Role deleted successfully" }, status: :ok
  end

  private

  def role_params
    params.require(:role).permit(:role_type)
  end
end
