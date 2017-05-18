require_relative 'parsers/parser_factory'

# Transforms a list of tokens into an Abstract Syntax Tree.
#
class Parser
  def parse(tokens)
    paragraphs = []
    while tokens.any?
      node = paragraph_parser.match(tokens)
      if node.present?
        raise "Expression matched but no tokens consumed" if node.consumed.zero?
        paragraphs += [node]
        tokens.grab!(node.consumed)
      else
        raise "Syntax error, invalid statement: #{tokens}"
      end
    end
    paragraphs
  end

  private

  def paragraph_parser
    @paragraph_parser ||= ParserFactory.build(:paragraph_parser)
  end
end
