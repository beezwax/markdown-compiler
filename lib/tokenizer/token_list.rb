class TokenList
  include Enumerable

  attr_reader :tokens
  def initialize(tokens)
    @tokens = tokens
  end

  def each(&block)
    tokens.each(&block)
  end

  def peek_or(*choices)
    choices.each do |tokens|
      return true if peek(*tokens)
    end
    false
  end

  def peek(*types)
    types.each_with_index do |type, index|
      return false if tokens.empty?
      return false if type != tokens[index].type
    end
    true
  end

  def peek_at(index, *types)
    return offset(index).peek(*types)
  end

  def grab!(amount)
    raise "Invalid amount requested" if amount > tokens.length
    tokens.shift(amount)
  end

  def offset(index)
    return self if index.zero?
    TokenList.new(tokens[index..-1])
  end

  def second
    tokens[1]
  end

  def third
    tokens[2]
  end

  def to_s
    "[\n\t#{tokens.map(&:to_s).join(",\n\t")}\n]"
  end
end
