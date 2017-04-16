require_relative 'parsers/parser_factory'

# Transforms a list of tokens into an Abstract Syntax Tree.
#
class Parser
  def parse(tokens)
    paragraphs = []
    while tokens.any?
      parser = ParserFactory.build(:paragraph_parser)
      if parser.is_match(tokens)
        raise "Expression matched but no tokens consumed" if parser.consumed.zero?
        paragraphs += [parser.node]
        tokens.grab!(parser.consumed)
      else
        raise "Syntax error, invalid statement: #{tokens}"
      end
    end
    paragraphs
  end
end
