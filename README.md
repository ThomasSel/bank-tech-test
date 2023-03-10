# Bank Tech Test

A small ruby bank implementation that allows the user to:

- create a bank account
- deposit/withdraw from this account
- create a formatted account statement
- save their account data to a `csv` file

from a REPL (eg `irb`).

# Running the project

To run this project, first clone the repository and run

```bash
bundle install
```

to install the required gems.

Open up a ruby REPL and run

```
> require_relative "bank"
```

to get access to the available classes (`Account`,`AccountStatement` and
`AccountIO`).

You can create an instance of the `Account` class, and start adding
transactions to it by using the `Account#deposit` and `Account#withdraw`
methods.
These methods both take and amount (number) and a date (string with
`yyyy-mm-dd` format) as parameters.

In order to get a formatted statement of an account, create a new instance
of `AccountStatement` with your account instance as an argument.
The `AccountStatement#statement` method will return a string with the
formatted statement.

To save / load your account to a file on your system, create a new instance
of `AccountIO` with your account instance as an argument.
The `AccountIO#save` method will save your account history to a `csv` file,
and the `AccountIO#load` method will load csv data from a file into the
account instance you initialized `AccountIO` with.

For an example of how to use these classes and their methods, an example use
case is added to `bank.rb`:

```ruby
account = Account.new
account_statement = AccountStatement.new(account)
account_io = AccountIO.new(account)

# Add account transactions
account.deposit(1000, "2023-01-10")
account.deposit(2000, "2023-01-13")
account.withdraw(500, "2023-01-14")

# Print a statement to the console
puts account_statement.statement
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
```

You can run this file from the command line by running

```bash
ruby bank.rb
```

To run the tests for this project, run

```bash
rspec
```

from the home directory

# Technical Details

The main account logic is contained in the `Account` class.
Internally, this class stores the transactions inside an array.
Each transaction is represented as a hash, which contains the type of
transaction, the amount, the date and the total balance of the account
after the transaction.
This array can be accessed using the `Account#transactions` method.
This class also ensures that we are not withdrawing too much money from
an account.

The two other classes handle account data:

- `AccountStatement` is responsible for generating a formatted account
  statement.
  It includes private methods to handle individual transaction formatting,
  and combines these into a single string with a header.
- `AccountIO` is responsible for reading and writing account data to `csv`
  files.
  The class checks the validity of filenames given as arguments to its methods
  and uses ruby's `File` class to perform IO operations.

# Things to Add

- Use a database instead of a file system to keep track of multiple accounts
  centrally.
- Create a command-line interface or web app to allow the user to easily add
  transactions to their account.
- Allow the user to perform more complex actions, such as transfers and
  standing orders.
- Add user info in order to differentiate between accounts and settings to
  allow for more customization.
