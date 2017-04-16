require_relative 'parser_factory'

class BaseParser
  attr_reader :node, :consumed
  def initialize
    @node     = nil
    @consumed = 0
  end

  protected

  # Tries to match one parser, the order is very important here as they get
  # tested first-in-first-tried.
  # If a parser matched, the function returns true, and assigns @node and
  # @consumed to the parser's @node and @consumed respectively.
  #
  def match_one(tokens, *parsers)
    parsers.find { |p| try_parser(tokens, p) } || false
  end

  def try_parser(tokens, parser)
    return false unless parser.is_match(tokens)
    @node     = parser.node
    @consumed = parser.consumed
    true
  end

  private

  def method_missing(name, *args, &block)
    raise ArgumentError.new("Method #{name} does not exist.") unless name.to_s.end_with?('_parser')
    ParserFactory.build(name, *args, &block)
  end
end
