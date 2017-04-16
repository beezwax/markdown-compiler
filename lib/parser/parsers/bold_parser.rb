require_relative 'base_parser'

class BoldParser < BaseParser
  def is_match(tokens)
    return false unless tokens.peek('UNDERSCORE', 'UNDERSCORE', 'TEXT', 'UNDERSCORE', 'UNDERSCORE')
    @node     = Node.new(type: 'BOLD', value: tokens.third.value)
    @consumed = 5
    true
  end
end
