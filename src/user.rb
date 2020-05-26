class User

  attr_reader :last_access, :username, :roles

  def self.call(username, scopes)
    self.new(username, scopes)
  end

  def initialize(username, roles)
    @last_access = Time.now.getlocal
    @username = username
    @roles = roles
  end

end