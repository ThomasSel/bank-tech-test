require "account"
require "account_statement"
require "account_io"

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

  describe "IO" do
    let(:file_mock) { double(:fake_file_class) }
    let(:account_io) { AccountIO.new(account, file_mock) }

    context "with an empty account" do
      it "raises an error" do
        expect{ account_io.save("account_01.csv") }.to raise_error(
          "You have not Deposited/Withdrawn from this account yet"
        )
      end
    end

    context "when writing to a file" do
      before(:each) do
        account.deposit(1000, "2023-01-10")
        account.deposit(2000, "2023-01-13")
        account.withdraw(500, "2023-01-14")
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
end
