require "account_io"

describe AccountIO do
  let(:account) { double() }
  let(:file_mock) { double() }
  let(:account_io) { AccountIO.new(account, file_mock) }

  describe "#save" do
    context "with a non csv filename" do
      it "raises an error" do
        expect{ account_io.save("account_01.txt") }.to raise_error(
          "You must input a csv file"
        )
        expect{ account_io.save("account_01.rb") }.to raise_error(
          "You must input a csv file"
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
      before(:each) do
        allow(account).to receive(:history).and_return([
          { type: :deposit, amount: 1000.0, date: Date.new(2023, 1, 10), balance: 1000.0 },
          { type: :deposit, amount: 2000.0, date: Date.new(2023, 1, 13), balance: 3000.0 },
          { type: :withdrawl, amount: 500.0, date: Date.new(2023, 1, 14), balance: 2500.0 }
        ])
      end

      it "successfully saves a header to the file" do
        expect(file_mock).to receive(:write).with("account_01.csv", include(
          "date, credit, debit, balance"
        ))

        account_io.save("account_01.csv")
      end

      it "saves transactions in correct order" do
        expect(file_mock).to receive(:write).with("account_01.csv", match(
          %r{2023-01-10.*\n2023-01-13.*\n2023-01-14}
        ))

        account_io.save("account_01.csv")
      end

      it "formats the output to csv" do
        expect(file_mock).to receive(:write).with("account_01.csv", include(
          "2023-01-10, 1000.00, 0.00, 1000.00",
          "2023-01-13, 2000.00, 0.00, 3000.00",
          "2023-01-14, 0.00, 500.00, 2500.00",
        ))

        account_io.save("account_01.csv")
      end
    end
  end

  describe "#load" do
    context "with a non csv filename" do
      it "raises an error" do
        expect{ account_io.load("account_01.txt") }.to raise_error(
          "You must input a csv file"
        )
        expect{ account_io.load("account_01.rb") }.to raise_error(
          "You must input a csv file"
        )
      end
    end

    context "when file doesn't exist" do
      it "raises an error" do
        allow(file_mock).to receive(:exist?)
          .with("account_01.rb")
          .and_return(false)
        
        expect{ account_io.load("account_01.csv") }.to raise_error(
          "The file account_01.csv doesn't exist"
        )
      end
    end
  end
end