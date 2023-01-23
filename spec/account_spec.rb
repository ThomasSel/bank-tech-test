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

      it "has deposits ordered as they were entered" do
        account = Account.new()
        account.deposit(99.99, "2023-01-15")
        account.deposit(1000, "2023-01-10")

        expect(account.history.first).to include(
          type: :deposit,
          amount: 99.99,
          date: Date.new(2023, 1, 15)
        )
      end
    end
  end
end
