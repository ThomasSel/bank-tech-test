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
  end
end