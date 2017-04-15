class Token
  attr_reader :type, :value
  def initialize(type:, value:)
    @type = type
    @value = value
  end

  def length
    value.length
  end

  def null?
    false
  end
end
