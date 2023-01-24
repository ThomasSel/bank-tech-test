require "date"

class Account
  def initialize
    @transactions = []
  end

  def deposit(amount, date_string)
    check_order(date_string)

    @transactions.push({
      type: :deposit,
      amount: amount.to_f,
      date: Date.parse(date_string),
      balance: add_to_balance(amount.to_f)
    })
  end

  def withdraw(amount, date_string)
    check_order(date_string)
    check_withdrawl_amount(amount)

    @transactions.push({
      type: :withdrawl,
      amount: amount.to_f,
      date: Date.parse(date_string),
      balance: add_to_balance(-amount.to_f)
    })
  end

  def history
    return @transactions
  end

  private

  def check_order(date_string)
    new_date = Date.parse(date_string)
    unless !@transactions.last || @transactions.last[:date] <= new_date
      raise ArgumentError.new("Transactions must be input chronologically")
    end
  end

  def check_withdrawl_amount(amount)
    balance = @transactions.last ? @transactions.last[:balance] : 0.0
    raise RuntimeError.new(
      "You cannot withdraw %.2f from your account, your current balance is %.2f" %
      [amount, balance]
    ) if balance < amount
  end

  def add_to_balance(amount)
    return @transactions.last ? @transactions.last[:balance] + amount : amount
  end
end
