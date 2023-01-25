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
The `AccountStatement#get_statement` method will return a string with the
formatted statement.

To save / load your account to a file on your system, create a new instance
of `AccountIO` with your account instance as an argument.
The `AccountIO#save` method will save your account history to a `csv` file,
and the `AccountIO#load` method will load csv data from a file into the
account instance you initialized `AccountIO` with.

For an example of how to use these classes and their methods, an example use
case is added to `bank.rb`, which you can run from the command line by
running

```bash
ruby bank.rb
```
