class TransactionsController < ApplicationController

  def index
    @transactions = current_user.account.transactions
  end


  def new
    @transaction = current_user.account.transactions.new
    @users       = User.where("id != ?", current_user.id)
  end


  def create
    @transaction = Transaction.new(transaction_params)
    status = current_user.allow_transaction(params[:transaction][:amount].to_f)
    @users       = User.where("id != ?", current_user.id)

    to_user = User.find_by_id(params[:transaction][:account_id])
    respond_to do |format|

      if @transaction.valid? && status
        debit_transaction = current_user.debit_amount(params[:transaction][:amount], "Credit transfer to #{to_user.name} Account-ID#{to_user.account.id}")
        credit_transaction = to_user.credit_amount(params[:transaction][:amount], "Credit transfer from #{current_user.name} Account-ID#{current_user.account.id}")
        format.html { redirect_to accounts_path, notice: 'Transaction was successfully created.' }
      else
        flash[:notice] = "You can not proceed for this transaction" unless status
        format.html { render :new}
      end
    end
  end


  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params.require(:transaction).permit(:amount, :name, :account_id)
    end
end
