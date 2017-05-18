module MatchesSentences
  # This method tries to match a sentence as many times as possible. It then
  # returns all matched nodes.
  #
  def match_sentences(tokens)
    matched_nodes = []
    consumed      = 0
    parser        = sentence_parser

    while true
      node = parser.match(tokens.offset(consumed))
      break if node.null?
      matched_nodes += [node]
      consumed      += node.consumed
    end

    [matched_nodes, consumed]
  end
end
