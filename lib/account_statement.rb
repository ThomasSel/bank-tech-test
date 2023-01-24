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
      statement_array << format_transaction(transaction)
    end
    return statement_array.join("\n")
  end

  private

  def format_date(date)
    date_string = date.to_s
    return date_string.split("-").reverse.join("/")
  end

  def format_transaction(transaction)
    return "%s || %s|| %s|| %.2f" % [
      format_date(transaction[:date]),
      transaction[:type] == :deposit ? "%.2f " % transaction[:amount] : nil,
      transaction[:type] == :withdrawl ? "%.2f " % transaction[:amount] : nil,
      transaction[:balance]
    ]
  end
end
