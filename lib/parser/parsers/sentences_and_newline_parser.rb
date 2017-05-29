require_relative "concerns/matches_star"

class SentencesAndNewlineParser < BaseParser
  include MatchesStar

  def match(tokens)
    nodes, consumed = match_star tokens, with: sentence_parser
    return Node.null if nodes.empty?
    return Node.null unless tokens.peek_at(consumed, 'NEWLINE', 'NEWLINE')
    consumed += 2 # consume newlines

    ParagraphNode.new(sentences: nodes, consumed: consumed)
  end
end
