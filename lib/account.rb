require("date")

class Account
  def initialize
    @transactions = []
  end

  def deposit(amount, date_string)
    unless chronological?(date_string)
      raise ArgumentError.new("transactions must be input chronologically")
    end
    @transactions.push({
      type: :deposit,
      amount: amount.to_f,
      date: Date.parse(date_string)
    })
  end

  def history
    return @transactions
  end

  private

  def chronological?(date_string)
    new_date = Date.parse(date_string)
    return !@transactions.last || @transactions.last[:date] < new_date
  end
end
