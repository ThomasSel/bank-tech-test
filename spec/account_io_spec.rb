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
  end
end