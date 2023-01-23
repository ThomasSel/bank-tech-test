require("date")
require("account")

describe Account do
  context "No transactions" do
    it "has no transaction information" do
      account = Account.new()
      expect(account.history).to eq([])
    end
  end

  describe "#deposit" do
    context "One deposit" do
      it "has a deposit of 1000 on 10/01/2023" do
        account = Account.new()
        account.deposit(1000, "2023-01-10")

        expect(account.history.first).to include(
          type: :deposit,
          amount: 1000.0,
          date: Date.new(2023, 1, 10)
        )
      end

      it "has a deposit of 99.99 on 15/01/2023" do
        account = Account.new()
        account.deposit(99.99, "2023-01-15")

        expect(account.history.first).to include(
          type: :deposit,
          amount: 99.99,
          date: Date.new(2023, 1, 15)
        )
      end
    end

    context "Two deposits" do
      it "has two deposits" do
        account = Account.new()
        account.deposit(1000, "2023-01-10")
        account.deposit(99.99, "2023-01-15")

        expect(account.history.length).to eq(2)
      end

      it "deposit dates must be chronological" do
        account = Account.new()
        account.deposit(99.99, "2023-01-15")
        expect{ account.deposit(1000, "2023-01-10") }.to raise_error(
          "transactions must be input chronologically"
        )
      end

      it "deposits on the same day are stored in the order they were input" do
        account = Account.new()
        account.deposit(1000, "2023-01-10")
        account.deposit(99.99, "2023-01-10")

        expect(account.history.last).to include(amount: 99.99)
      end
    end
  end

  describe "#withdraw" do
    context "empty account" do
      it "raises when withdrawing" do
        account = Account.new()
        expect{ account.withdraw(10, "2023-01-10") }.to raise_error(
          "You cannot withdraw 10.00 from your account, your current balance is 0.00"
        )
      end
    end
    
    context "account with a balance of 100.00" do
      it "can withdraw 40" do
        account = Account.new()
        account.deposit(90, "2023-01-01")
        account.deposit(10, "2023-01-02")
        account.withdraw(40, "2023-01-10")
        
        expect(account.history.last).to include(
          type: :withdrawl,
          amount: 40.0,
          date: Date.new(2023, 1, 10)
        )
      end

      it "can withdraw 40.0" do
        account = Account.new()
        account.deposit(90, "2023-01-01")
        account.deposit(10, "2023-01-02")
        account.withdraw(40.0, "2023-01-10")
        
        expect(account.history.last).to include(
          type: :withdrawl,
          amount: 40.0,
          date: Date.new(2023, 1, 10)
        )
      end
    end
  end
end
