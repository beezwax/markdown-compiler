class Token
  attr_reader :type, :value
  def initialize(type:, value:)
    @type = type
    @value = value
  end
end
