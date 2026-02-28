class Api::V1::ClientsController < ApplicationController
  before_action :find_client, only: [:show, :destroy, :update]

  # GET api/v1/clients
  def index
    @clients = Client.where(establishment_id: current_user.current_establishment_id)

    render json: {status: "success", data: {clients: @clients}}
  end

  # GET api/v1/clients/:id
  def show
    render json: {status: "success", data: {client: @client}}
  end

  # POST api/v1/clients
  def create
    @client = Client.new(client_params)
    @client.establishment_id = current_user.current_establishment_id
    if @client.save
      render json: {status: "success", data: {client: @client}}, status: :created
    else
      render json: {status: "fail", error: {message: "Couldn't create client"}}, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    render json: {status: "fail", error: {message: "A client with this phone number already exists."}}
  end

  # DELETE api/v1/clients/:id
  def destroy
    @client.destroy
  end

  # UPDATE api/v1/clients/:id
  def update
    if @client.update(client_params)
      render json: {status:"success", data: {client: @client}}
    else
      render json: {status: "fail", error: {message: "Couldn't update client"}}, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    render json: {status: "fail", error: {message: "A client with this phone number already exists."}}, status: :unprocessable_entity
  end

  private

  # Find client by his id
  def find_client
    @client = Client.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {status: "fail", error:{message: "Couldn't find client with id #{params[:id]}"}}, status: :not_found
  end

  # Permit client request params
  def client_params
    params.require(:client).permit(:name, :phone_number, :is_partener, :credit)
  end
end
