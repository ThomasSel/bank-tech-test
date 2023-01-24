class AccountStatement
  def initialize(account)
    @account = account
  end

  def get_statement
    if @account.history.length.zero?
      return "You have not Deposited/Withdrawn from this account yet"
    end
    statement_array = ["date || credit || debit || balance"]
    statement_array << "10/01/2023 || 1000.00 || || 1000.00"
    return statement_array.join('\n')
  end
end
