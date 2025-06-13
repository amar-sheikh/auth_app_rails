class TransactionsController < ApplicationController
  layout 'logged_in'

  before_action :authenticate_user!

  def index
    @transactions = Transaction.all
  end

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      redirect_to transactions_path, notice: "Transaction was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def transaction_params
      params.require(:transaction).permit(:user_id, :address_id, :idempotency_key, :amount, :additional_info)
    end
end
