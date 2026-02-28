class Api::V1::SalePointsController < ApplicationController
  before_action :find_sale_point, only: [:show]
  def index
    @sale_points = SalePoint.includes(:truck, :warehouse).where(establishment_id: current_user.current_establishment_id)

    render json: { status: "success", data: { sale_points: @sale_points.as_json(include: {truck:{}, warehouse:{}}) } }
  end

  def show
    @sale_point = SalePoint.includes(:truck, :warehouse, :establishment).find(params[:id])

    render json: { status: "success", data: { sale_point: @sale_point.as_json(include: {truck:{}, warehouse:{}, establishment: {}}) } }
  end

  def create
    ActiveRecord::Base.transaction do
      @sale_point = SalePoint.new(sale_point_params)
      @sale_point.establishment_id = current_user.current_establishment_id

      if @sale_point.save
        related_entity = create_related_entity(@sale_point)

        render json: { status: "success", data: { sale_point: @sale_point, truck: related_entity } }, status: :created if @sale_point.sale_point_type == "truck"
        render json: { status: "success", data: { sale_point: @sale_point, warehouse: related_entity } }, status: :created if @sale_point.sale_point_type == "warehouse"        if @sale_point.sale_point_type == "warehouse"
      else
        render json: { status: "fail", error: { message: @sale_point.errors.full_messages.join(", ") } }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  rescue => e
    render json: { status: "fail", error: { message: e.message } }, status: :unprocessable_entity
  end

  private

  def sale_point_params
    params.require(:sale_point).permit(:sale_point_type)
  end

  def truck_params
    params.require(:truck).permit(:matricule, :marque)
  end

  def warehouse_params
    params.require(:warehouse).permit(:name, :location)
  end

  def create_related_entity(sale_point)
    case sale_point.sale_point_type
    when "truck"
      Truck.create!(truck_params.merge(sale_point_id: sale_point.id))
    when "warehouse"
      Warehouse.create!(warehouse_params.merge(sale_point_id: sale_point.id))
    end
  end

  def find_sale_point
    @sale_point = SalePoint.find(params[:id])
  end
end
