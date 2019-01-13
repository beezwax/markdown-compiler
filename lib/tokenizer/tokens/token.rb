require_relative 'null_token'

# A base token. The tokenizer returns an array of these. Each token has a type
# and a value. None can be nil.
#
class Token
  attr_reader :type, :value
  def initialize(type:, value:)
    @type = type
    @value = value
    raise InvalidTokenError if value.nil? || type.nil?
  end

  def self.null
    NullToken.new
  end

  def self.end_of_file
    Token.new(type: 'EOF', value: '')
  end

  def length
    value.length
  end

  def null?
    false
  end

  def present?
    true
  end

  def to_s
    "<type: #{type}, value: #{value}>"
  end
end

class InvalidTokenError < RuntimeError; end
