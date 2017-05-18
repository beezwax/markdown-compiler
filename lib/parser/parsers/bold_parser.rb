require_relative 'base_parser'

class BoldParser < BaseParser
  def is_match(tokens)
    return Node.null unless tokens.peek('UNDERSCORE', 'UNDERSCORE', 'TEXT', 'UNDERSCORE', 'UNDERSCORE')
    Node.new(type: 'BOLD', value: tokens.third.value, consumed: 5)
  end
end
