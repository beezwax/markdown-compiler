require_relative 'base_parser'

class EmphasisParser < BaseParser
  def match(tokens)
    return Node.null unless tokens.peek('UNDERSCORE', 'TEXT', 'UNDERSCORE')
    Node.new(type: 'EMPHASIS', value: tokens.second.value, consumed: 3)
  end
end
