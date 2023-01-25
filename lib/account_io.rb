class AccountIO
  def initialize(account, file_class=File)
    @account = account
    @file_class = file_class
  end

  def save(filename)
    if !filename.match?(/\.csv$/)
      raise "You must input a csv file"
    elsif @account.transactions.empty?
      raise "You have not Deposited/Withdrawn from this account yet"
    end

    output_array = ["date, credit, debit, balance"]
    @account.transactions.each do |transaction|
      output_array << format_transaction(transaction)
    end
    @file_class.write(filename, output_array.join("\n"))
  end

  def load(filename)
    if !filename.match?(/\.csv$/)
      raise "You must input a csv file"
    elsif !@file_class.exist?(filename)
      raise "The file #{filename} doesn't exist"
    end

    @file_class.open(filename) do |file|
      @account.reset
      file.readline  # Skip the header
      file.readlines.each do |line|
        parse_file_line(line)
      end
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

  def parse_file_line(line)
    line_array = line.split(",").map(&:strip)

    if line_array[1] == "0.00"
      @account.withdraw(line_array[2].to_f, line_array[0])
    elsif line_array[2] == "0.00"
      @account.deposit(line_array[1].to_f, line_array[0])
    end
  end
end
