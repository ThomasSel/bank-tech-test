require_relative "lib/account"
require_relative "lib/account_statement"
require_relative "lib/account_io"

if __FILE__ == $0
  account = Account.new
  account_statement = AccountStatement.new(account)
  account_io = AccountIO.new(account)

  # Add account transactions
  account.deposit(1000, "2023-01-10")
  account.deposit(2000, "2023-01-13")
  account.withdraw(500, "2023-01-14")

  # Print a statement to the console
  puts account_statement.get_statement
  # date || credit || debit || balance
  # 14/01/2023 || || 500.00 || 2500.00
  # 13/01/2023 || 2000.00 || || 3000.00
  # 10/01/2023 || 1000.00 || || 1000.00

  # Save the account to temp.csv
  account_io.save("temp.csv")

  # Reset the account history
  account.reset

  # Load the account from temp.csv
  account_io.load("temp.csv")
end
