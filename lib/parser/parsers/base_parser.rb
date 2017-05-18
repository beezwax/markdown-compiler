require_relative 'parser_factory'

class BaseParser
  # Tries to match one parser, the order is very important here as they get
  # tested first-in-first-tried.
  # If a parser matched, the function returns the matched node, otherwise, it
  # returns a null node.
  #
  def match_first(tokens, *parsers)
    parsers.each do |parser|
      node = parser.match(tokens)
      return node if node.present?
    end
    Node.null
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
