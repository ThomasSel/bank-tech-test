require "date"
require "account"

describe Account do
  let(:account) { Account.new() }

  context "No transactions" do
    it "has no transaction information" do
      expect(account.history).to eq([])
    end
  end

  describe "#deposit" do
    context "One deposit" do
      it "has a deposit of 1000 on 10/01/2023" do
        account.deposit(1000, "2023-01-10")

        expect(account.history.first).to include(
          type: :deposit,
          amount: 1000.0,
          date: Date.new(2023, 1, 10),
          balance: 1000.0
        )
      end

      it "has a deposit of 99.99 on 15/01/2023" do
        account.deposit(99.99, "2023-01-15")

        expect(account.history.first).to include(
          type: :deposit,
          amount: 99.99,
          date: Date.new(2023, 1, 15),
          balance: 99.99
        )
      end
    end

    context "Two deposits" do
      it "has two deposits" do
        account.deposit(1000, "2023-01-10")
        account.deposit(99.99, "2023-01-15")

        expect(account.history.length).to eq(2)
      end

      it "adds up the deposits in the balance" do
        account.deposit(1000, "2023-01-10")
        account.deposit(99.99, "2023-01-15")

        expect(account.history.last[:balance]).to eq(1099.99)
      end

      it "deposit dates must be chronological" do
        account.deposit(99.99, "2023-01-15")
        expect{ account.deposit(1000, "2023-01-10") }.to raise_error(
          "Transactions must be input chronologically"
        )
      end

      it "deposits on the same day are stored in the order they were input" do
        account.deposit(1000, "2023-01-10")
        account.deposit(99.99, "2023-01-10")

        expect(account.history.last).to include(amount: 99.99)
      end
    end
  end

  describe "#withdraw" do
    context "empty account" do
      it "raises when withdrawing" do
        expect{ account.withdraw(10, "2023-01-10") }.to raise_error(
          "You cannot withdraw 10.00 from your account, your current balance is 0.00"
        )
      end
    end

    context "account with a balance of 100.00" do
      before(:each) do
        account.deposit(90, "2023-01-01")
        account.deposit(10, "2023-01-02")
      end

      context "one withdrawl" do
        it "can withdraw 40" do
          account.withdraw(40, "2023-01-10")

          expect(account.history.last).to include(
            type: :withdrawl,
            amount: 40.0,
            date: Date.new(2023, 1, 10)
          )
        end

        it "can withdraw 49.99" do
          account.withdraw(49.99, "2023-01-10")

          expect(account.history.last).to include(
            type: :withdrawl,
            amount: 49.99,
            date: Date.new(2023, 1, 10)
          )
        end

        it "raises when withdrawing more than 100" do
          expect{ account.withdraw(150, "2023-01-10") }.to raise_error(
            "You cannot withdraw 150.00 from your account, your current balance is 100.00"
          )
          expect{ account.withdraw(149.99, "2023-01-10") }.to raise_error(
            "You cannot withdraw 149.99 from your account, your current balance is 100.00"
          )
        end

        it "raises if date isn't after deposit" do
          expect{ account.withdraw(49.99, "2023-01-01") }.to raise_error(
            "Transactions must be input chronologically"
          )
        end
      end

      context "two withdrawls" do
        it "raises when withdrawing 40, then 100" do
          account.withdraw(40, "2023-01-10")
          expect{ account.withdraw(100, "2023-01-11") }.to raise_error(
            "You cannot withdraw 100.00 from your account, your current balance is 60.00"
          )
        end

        it "adds two transactions" do
          account.withdraw(20, "2023-01-02")
          account.withdraw(50, "2023-01-03")

          expect(account.history.length).to eq(4)
        end

        it "updates the balance" do
          account.withdraw(20, "2023-01-02")
          account.withdraw(50, "2023-01-03")
          
          expect(account.history.last[:balance]).to be(30.0)
        end

        it "fails if the withdrawls aren't chronological" do
          account.withdraw(50, "2023-01-03")
          expect{ account.withdraw(20, "2023-01-02") }.to raise_error(
            "Transactions must be input chronologically"
          )
        end

        it "withdrawls on the same day are stored in the order they were input" do
          account.withdraw(20, "2023-01-02")
          account.withdraw(50, "2023-01-02")

          expect(account.history.last[:amount]).to be(50.0)
        end
      end
    end
  end

  describe "#reset" do
    context "with several transactions" do
      it "removes the transactions from the history" do
        account.deposit(500, "2023-01-01")
        account.withdraw(500, "2023-01-02")
        account.reset

        expect(account.history.length).to eq(0)
      end
    end
  end
end
