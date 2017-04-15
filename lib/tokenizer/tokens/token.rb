require_relative 'null_token'

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

  def length
    value.length
  end

  def null?
    false
  end
end

class InvalidTokenError < Exception; end
