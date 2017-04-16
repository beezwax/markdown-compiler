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

  # TODO: Return NulLNode instead of false? Maybe we can reuse parsers like that
  # @consumed could live in the node itself.
  def try_parser(tokens, parser)
    return false unless parser.is_match(tokens)
    @node     = parser.node
    @consumed = parser.consumed
    true
  end

  private

  # TODO: If we can reuse parsers, then this should be memoized:
  # @parser_cache[name] ||= ParserFactory.build(...)
  # That would work as long as we don't need any *args for the parsers.
  def method_missing(name, *args, &block)
    raise ArgumentError.new("Method #{name} does not exist.") unless name.to_s.end_with?('_parser')
    ParserFactory.build(name, *args, &block)
  end
end
