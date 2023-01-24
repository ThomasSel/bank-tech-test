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
    elsif !@file.exist?(filename)
      raise "The file #{filename} doesn't exist"
    end

    load_file = @file.new(filename)
    load_file.readline  # Skip the header
    load_file.readlines.each do |line|
      line_array = line.split(",").map(&:strip)
      if line_array[1] == "0.00"
        @account.withdraw(line_array[2].to_f, line_array[0])
      elsif line_array[2] == "0.00"
        @account.deposit(line_array[1].to_f, line_array[0])
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
end
