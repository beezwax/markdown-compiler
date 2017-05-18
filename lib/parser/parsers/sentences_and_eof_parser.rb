require_relative "concerns/matches_sentences"

class SentencesAndEofParser < BaseParser
  include MatchesSentences

  def match(tokens)
    nodes, consumed = match_sentences(tokens)

    return Node.null if nodes.empty?
    if tokens.peek_at(consumed, 'EOF')
      consumed += 1
    elsif tokens.peek_at(consumed, 'NEWLINE', 'EOF')
      consumed += 2
    else
      return Node.null
    end

    SentenceNode.new(sentences: nodes, consumed: consumed)
  end
end
