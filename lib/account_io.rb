class AccountIO
  def initialize(account, io)
    @account = account
  end

  def save(filename)
    raise "You have not Deposited/Withdrawn from this account yet"
  end
end
