class AccountStatement
  def initialize(account)
    @account = account
  end

  def get_statement
    return "You have not Deposited/Withdrawn from this account yet"
  end
end
