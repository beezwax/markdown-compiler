require_relative "concerns/matches_sentences"

class SentencesAndNewlineParser < BaseParser
  include MatchesSentences
  
  def is_match(tokens)
    nodes, consumed = match_sentences(tokens)
    return Node.null if nodes.empty?
    return Node.null unless tokens.peek_at(consumed, 'NEWLINE', 'NEWLINE')
    consumed += 2 # consume newlines

    SentenceNode.new(sentences: nodes, consumed: consumed)
  end
end
