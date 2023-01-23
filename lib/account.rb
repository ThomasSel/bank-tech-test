require("date")

class Account
  def initialize
    @transactions = []
  end

  def deposit(amount, date)
    @transactions.push({
      type: :deposit,
      amount: amount.to_f,
      date: Date.parse(date)
    })
  end

  def history
    return @transactions
  end
end
