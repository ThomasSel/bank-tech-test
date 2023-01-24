class AccountStatement
  def initialize(account)
    @account = account
  end

  def get_statement
    if @account.history.length.zero?
      return "You have not Deposited/Withdrawn from this account yet"
    end
    return "date || credit || debit || balance"
  end
end
