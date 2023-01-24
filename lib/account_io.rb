class AccountIO
  def initialize(account, file=File)
    @account = account
    @file = file
  end

  def save(filename)
    if !filename.match?(/\.csv$/)
      raise "You must input a csv file"
    elsif @account.history.empty?
      raise "You have not Deposited/Withdrawn from this account yet"
    end

    output_array = ["date, credit, debit, balance"]
    @account.history.each do |transaction|
      output_array << format_transaction(transaction)
    end
    @file.write(filename, output_array.join("\n"))
  end

  def load(filename)
    if !filename.match?(/\.csv$/)
      raise "You must input a csv file"
    elsif !File.exist?(filename)
      raise "The file #{filename} doesn't exist"
    end


  end

  private

  def format_transaction(transaction)
    return "%s, %s, %s, %.2f" % [
      transaction[:date].to_s,
      transaction[:type] == :deposit ? "%.2f" % transaction[:amount] : "0.00",
      transaction[:type] == :withdrawl ? "%.2f" % transaction[:amount] : "0.00",
      transaction[:balance]
    ]
  end
end
