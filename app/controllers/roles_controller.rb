class RolesController < ApplicationController
  # POST /roles
  def create
    @role = Role.new(role_params)
    if @role.save
      render json: @role, status: :created
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  # GET /roles
  def index
    @roles = Role.all
    render json: @roles
  end

  # GET /roles/:id
  def show
    @role = Role.find(params[:id])
    render json: @role
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Role not found" }, status: :not_found
  end

  # PUT/PATCH /roles/:id
  def update
    @role = Role.find(params[:id])
    if @role.update(role_params)
      render json: @role
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Role not found" }, status: :not_found
  end

  # DELETE /roles/:id
  def destroy
    @role = Role.find(params[:id])
    @role.destroy
    render json: { message: "Role deleted successfully" }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Role not found" }, status: :not_found
  end

  private

  def role_params
    params.require(:role).permit(:role_type)
  end
end
