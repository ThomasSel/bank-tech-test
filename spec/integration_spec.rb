require "account"
require "account_statement"
require "account_io"

describe "Integration" do
  let(:account) { Account.new }
  let(:account_statement) { AccountStatement.new(account) }

  context "with no deposit/withdrawl" do
    it "returns a message" do
      expect(account_statement.statement).to eq(
        "You have not Deposited/Withdrawn from this account yet",
      )
    end
  end

  context "with one deposit" do
    it "returns a string with a header" do
      account.deposit(1000, "2023-01-10")

      expect(account_statement.statement).to include(
        "date || credit || debit || balance",
      )
    end

    it "returns a string with the deposit made" do
      account.deposit(1000, "2023-01-10")

      expect(account_statement.statement).to include(
        "10/01/2023 || 1000.00 || || 1000.00",
      )
    end
  end

  context "with successive deposits and a valid withdrawl" do
    before(:each) do
      account.deposit(1000, "2023-01-10")
      account.deposit(2000, "2023-01-13")
      account.withdraw(500, "2023-01-14")
    end

    it "prints out statement with newest transaction first" do
      expect(account_statement.statement).to match(
        %r{14/01/2023.*\n13/01/2023.*\n10/01/2023},
      )
    end

    it "prints out correct transaction details" do
      expect(account_statement.statement).to include(
        "14/01/2023 || || 500.00 || 2500.00",
        "13/01/2023 || 2000.00 || || 3000.00",
        "10/01/2023 || 1000.00 || || 1000.00",
      )
    end
  end

  context "with a series of valid deposits/withdrawls" do
    before(:each) do
      account.deposit(300, "2023-01-11")
      account.withdraw(150, "2023-01-11")
      account.withdraw(50, "2023-01-12")
      account.deposit(40, "2023-01-14")
    end

    it "prints out statement with newest transaction first" do
      expect(account_statement.statement).to match(
        %r{14/01/2023.*\n12/01/2023.*\n11/01/2023.*\n11/01/2023},
      )
    end
    
    it "prints out correct transaction details" do
      expect(account_statement.statement).to include(
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

    context "when loading from a file" do
      before(:each) do
        allow(file_mock).to receive(:exist?)
          .with("account_01.csv")
          .and_return(true)

        io_mock = double(:fake_io)
        expect(io_mock).to receive(:readline)
        expect(io_mock).to receive(:readlines).and_return([
          "2023-01-10, 1000.00, 0.00, 1000.00",
          "2023-01-13, 2000.00, 0.00, 3000.00",
          "2023-01-14, 0.00, 500.00, 2500.00"
        ])

        expect(file_mock).to receive(:open)
          .with("account_01.csv")
          .and_yield(io_mock)
      end

      it "updates the account history" do
        account_io.load("account_01.csv")

        expect(account.transactions).to include(
          include(type: :deposit, amount: 1000.0),
          include(type: :deposit, amount: 2000.0),
          include(type: :withdrawl, amount: 500.0),
        )
      end

      it "produces the right formatted statement" do
        account_io.load("account_01.csv")

        expect(account_statement.statement).to include(
          "date || credit || debit || balance",
          "14/01/2023 || || 500.00 || 2500.00",
          "13/01/2023 || 2000.00 || || 3000.00",
          "10/01/2023 || 1000.00 || || 1000.00"
        )
      end

      it "resets the account if it already has transactions" do
        account.deposit(100.0, "2023-01-01")
        account_io.load("account_01.csv")

        expect(account.transactions).not_to include(
          include(type: :deposit, amount: 100.0)
        )
      end
    end
  end
end
