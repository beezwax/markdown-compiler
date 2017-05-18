require_relative 'base_parser'

class TextParser < BaseParser
  def is_match(tokens)
    return Node.null unless tokens.peek('TEXT')
    Node.new(type: 'TEXT', value: tokens.first.value, consumed: 1)
  end
end
