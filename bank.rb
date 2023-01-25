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

  # Save the account to temp.csv
  account_io.save("temp.csv")
end
