class Api::V1::ExpensesController < ApplicationController
  before_action :find_expense, only: [:show, :destroy, :update]

  # GET api/v1/expenses
  def index
    @expenses = Expense.where({establishment_id: current_user.current_establishment_id})

    if valid_date?(params[:from]) && valid_date?(params[:to])
      from_date = Date.parse(params[:from])
      to_date = Date.parse(params[:to])
      @expenses = @expenses.where(created_at: from_date.beginning_of_day..to_date.end_of_day)

      render json: { status: 'success', data: { expenses: @expenses } }
    elsif valid_date?(params[:date])
      current_date = Date.parse(params[:date])
      @expenses = @expenses.where(created_at: current_date.beginning_of_day..current_date.end_of_day)

      render json: { status: 'success', data: { expenses: @expenses } }
    else
      render json: {status: 'success', data: {expenses: []}}
    end

  end


  # GET api/v1/expenses/:id
  def show
    render json: {status: "success", data: {expense: @expense}}
  end

  # POST api/v1/expenses
  def create
    @expense = Expense.new(expense_params)
    @expense.establishment_id = current_user.current_establishment_id

    if @expense.save
      render json: {status: "success", data: {expense: @expense}}, status: :created
    else
      render json: {status: "fail", error: {message: "Couldn't create expense"}}, status: :unprocessable_entity
    end
  end

  # UPDATE api/v1/expenses/:id
  def update
    # Ensure establishment_id is not changed
    params_to_update = expense_params
    if @expense.update(params_to_update)
      render json: {status: "success", data: {expense: @expense} }
    else
      render json: {status: "fail", error: {message: "Couldn't update expense"}}, status: :unprocessable_entity
    end
  end

  # DELETE api/v1/expenses/:id
  def destroy
    @expense.destroy
  end

  private

  # Find expense by id
  def find_expense
    @expense = Expense.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {status: "fail", error: {message: "Expense with id #{params[:id]} not found"}}, status: :not_found
  end

  # Permit expense request params
  def expense_params
    params.require(:expense).permit(:user_id, :amount, :reason, :sale_point_id)
  end

  def valid_date?(date_string)
    Date.iso8601(date_string) rescue false
  end
end
