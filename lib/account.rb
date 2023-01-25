require "date"

class Account
  def initialize
    @transactions = []
  end

  def deposit(amount, date_string)
    check_order(date_string)
    check_deposit_amount(amount)

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

  def reset
    @transactions = []
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
    if balance < amount
      raise RuntimeError.new(
        "You cannot withdraw %.2f from your account, your current balance is %.2f" %
        [amount, balance]
      )
    elsif amount <= 0
      raise ArgumentError.new("You must withdraw more than 0 from your account")
    end
  end

  def check_deposit_amount(amount)
    if amount <= 0
      raise ArgumentError.new("You must deposit more than 0 to your account")
    end
  end

  def add_to_balance(amount)
    return @transactions.last ? @transactions.last[:balance] + amount : amount
  end
end
