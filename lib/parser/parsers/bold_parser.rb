require_relative 'base_parser'

class BoldParser < BaseParser
  def match(tokens)
    return Node.null unless tokens.peek_or(%w(UNDERSCORE UNDERSCORE TEXT UNDERSCORE UNDERSCORE), %w(STAR STAR TEXT STAR STAR))
    Node.new(type: 'BOLD', value: tokens.third.value, consumed: 5)
  end
end
