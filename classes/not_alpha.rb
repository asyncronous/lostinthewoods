class NotAlpha < StandardError
  def initialize(msg = "Invalid Input: Name must only use standard alpha characters a-z and A-Z")
    super(msg)
  end
end

def check_if_alpha(input)
  input =~ /[[:alpha:]]/
end

def alpha_err(result)
  raise NotAlpha if result == nil
end
