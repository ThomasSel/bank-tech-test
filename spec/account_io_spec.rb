require "account_io"

describe AccountIO do
  let(:account) { double() }
  let(:file_mock) { double() }
  let(:account_io) { AccountIO.new(account, file_mock) }

  describe "#save" do
    context "with a non csv filename" do
      it "raises an error" do
        expect{ account_io.save("account_01.txt") }.to raise_error(
          "You must save the account to a csv file"
        )
        expect{ account_io.save("account_01.rb") }.to raise_error(
          "You must save the account to a csv file"
        )
      end
    end

    context "with an empty account" do
      it "raises an error" do
        allow(account).to receive(:history).and_return([])
        expect{ account_io.save("account_01.csv") }.to raise_error(
          "You have not Deposited/Withdrawn from this account yet"
        )
      end
    end

    context "with a series of valid deposits/withdrawls" do
      it "successfully saves a header to the file" do
        allow(account).to receive(:history).and_return([
          { type: :deposit, amount: 1000.0, date: Date.new(2023, 1, 10), balance: 1000.0 },
          { type: :deposit, amount: 2000.0, date: Date.new(2023, 1, 13), balance: 3000.0 },
          { type: :withdrawl, amount: 500.0, date: Date.new(2023, 1, 14), balance: 2500.0 }
        ])
        expect(file_mock).to receive(:write).with("account_01.csv", include(
          "date, credit, debit, balance"
        ))

        account_io.save("account_01.csv")
      end
    end
  end
end