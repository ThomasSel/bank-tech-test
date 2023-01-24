class AccountIO
  def initialize(account, file=File)
    @account = account
    @file = file
  end

  def save(filename)
    if !filename.match?(/\.csv$/)
      raise "You must save the account to a csv file"
    elsif @account.history.empty?
      raise "You have not Deposited/Withdrawn from this account yet"
    end
  end
end
