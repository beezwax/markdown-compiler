require_relative 'base_parser'

class TextParser < BaseParser
  def is_match(tokens)
    return false unless tokens.peek('TEXT')
    @node     = Node.new(type: 'TEXT', value: tokens.first.value)
    @consumed = 1
    true
  end
end
