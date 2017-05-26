module MatchesFirst
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
end
