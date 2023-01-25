require "account_statement"

describe AccountStatement do
  let(:account) { double() }
  let(:account_statement) { AccountStatement.new(account) }

  describe "get_statement" do
    context "when account is empty" do
      it "returns a message" do
        expect(account).to receive(:history).and_return([])
        expect(account_statement.get_statement).to eq(
          "You have not Deposited/Withdrawn from this account yet"
        )
      end
    end

    context "with one deposit" do
      before(:each) do
        allow(account).to receive(:history).and_return([{
          type: :deposit,
          amount: 100,
          date: Date.new(2023, 1, 1),
          balance: 100
        }])
      end

      it "returns a string with a header" do
        expect(account_statement.get_statement).to include(
          "date || credit || debit || balance"
        )
      end

      it "returns a formatted line with the deposit" do
        expect(account_statement.get_statement).to include(
          "01/01/2023 || 100.00 || || 100.00"
        )
      end
    end

    context "with one withdrawl" do
      before(:each) do
        allow(account).to receive(:history).and_return([{
          type: :withdrawl,
          amount: 100,
          date: Date.new(2023, 1, 1),
          balance: -100
        }])
      end

      it "returns a string with a header" do
        expect(account_statement.get_statement).to include(
          "date || credit || debit || balance"
        )
      end

      it "returns a formatted line with the withdrawl" do
        expect(account_statement.get_statement).to include(
          "01/01/2023 || || 100.00 || -100.00"
        )
      end
    end

    context "with one deposit and one withdrawl" do
      before(:each) do
        allow(account).to receive(:history).and_return([
          {
            type: :deposit,
            amount: 150,
            date: Date.new(2023, 1, 1),
            balance: 150
          }, {
            type: :withdrawl,
            amount: 100,
            date: Date.new(2023, 1, 2),
            balance: 50
          }
        ])
      end

      it "returns a string with a header" do
        expect(account_statement.get_statement).to include(
          "date || credit || debit || balance"
        )
      end

      it "returns a string with transactions in reverse order" do
        expect(account_statement.get_statement).to match(
          %r{02/01/2023.*\n01/01/2023}
        )
      end

      it "correctly formats the output" do
        expect(account_statement.get_statement).to include(
          "02/01/2023 || || 100.00 || 50.00",
          "01/01/2023 || 150.00 || || 150.00"
        )
      end
    end
  end
end
