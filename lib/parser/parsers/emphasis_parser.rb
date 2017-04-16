require_relative 'base_parser'

class EmphasisParser < BaseParser
  def is_match(tokens)
    return false unless tokens.peek('UNDERSCORE', 'TEXT', 'UNDERSCORE')
    @node     = Node.new(type: 'EMPHASIS', value: tokens.second.value)
    @consumed = 3
    true
  end
end
