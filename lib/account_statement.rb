class AccountStatement
  def initialize(account)
    @account = account
  end

  def get_statement
    if @account.history.length.zero?
      return "You have not Deposited/Withdrawn from this account yet"
    end
    statement_array = ["date || credit || debit || balance"]
    @account.history.reverse.each do |transaction|
      statement_array << "%s || %.2f || || %.2f" % [
        transaction[:date].to_s.split("-").reverse.join("/"),
        transaction[:amount],
        transaction[:balance]
      ]
    end
    return statement_array.join("\n")
  end
end
