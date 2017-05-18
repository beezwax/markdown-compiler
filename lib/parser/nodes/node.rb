require_relative 'null_node'

class Node
  attr_reader :type, :value, :consumed
  def initialize(type:, value:, consumed:)
    @type = type
    @value = value
    @consumed = consumed
  end

  def null?
    false
  end

  def present?
    true
  end

  def self.null
    @@null_node ||= NullNode.new
  end
end
