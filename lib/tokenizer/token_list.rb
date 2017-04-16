class TokenList
  include Enumerable

  attr_reader :tokens
  def initialize(tokens)
    @tokens = tokens
  end

  def each(&block)
    tokens.each(&block)
  end

  def peek(*types)
    types.each_with_index do |type, index|
      return false if type != @tokens[index].type
    end
    true
  end

  def grab!(amount)
    raise "Invalid amount requested" if amount > tokens.length
    tokens.shift(amount)
  end

  def second
    tokens[1]
  end

  def third
    tokens[2]
  end
end