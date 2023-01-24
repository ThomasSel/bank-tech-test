require("account")
require("account_statement")

describe "Integration" do
  let(:account) { Account.new }
  let(:account_statement) { AccountStatement.new(account) }

  context "no deposit/withdrawl" do
    it "returns a message" do
      expect(account_statement.get_statement).to eq(
        "You have not Deposited/Withdrawn from this account yet",
      )
    end
  end

  context "one deposit" do
    it "returns a string with a header" do
      account.deposit(1000, "2023-01-10")

      expect(account_statement.get_statement).to include(
        "date || credit || debit || balance",
      )
    end

    it "returns a string with the deposit made" do
      account.deposit(1000, "2023-01-10")

      expect(account_statement.get_statement).to include(
        "10/01/2023 || 1000.00 || || 1000.00",
      )
    end
  end

  context "successive deposits and a valid withdrawl" do
    before(:each) do
      account.deposit(1000, "2023-01-10")
      account.deposit(2000, "2023-01-13")
      account.withdraw(500, "2023-01-14")
    end

    it "prints out statement with newest transaction first" do
      expect(account_statement.get_statement).to match(
        %r{14/01/2023.*\n13/01/2023.*\n10/01/2023},
      )
    end

    it "prints out correct transaction details" do
      expect(account_statement.get_statement).to include(
        "14/01/2023 || || 500.00 || 2500.00",
        "13/01/2023 || 2000.00 || || 3000.00",
        "10/01/2023 || 1000.00 || || 1000.00",
      )
    end
  end

  context "series of valid deposits/withdrawls" do
    before(:each) do
      account.deposit(300, "2023-01-11")
      account.withdraw(150, "2023-01-11")
      account.withdraw(50, "2023-01-12")
      account.deposit(40, "2023-01-14")
    end

    it "prints out statement with newest transaction first" do
      expect(account_statement.get_statement).to match(
        %r{14/01/2023.*\n12/01/2023.*\n11/01/2023.*\n11/01/2023},
      )
    end
    
    it "prints out correct transaction details" do
      expect(account_statement.get_statement).to include(
        "14/01/2023 || 40.00 || || 140.00",
        "12/01/2023 || || 50.00 || 100.00",
        "11/01/2023 || || 150.00 || 150.00",
        "11/01/2023 || 300.00 || || 300.00",
      )
    end
  end
end
