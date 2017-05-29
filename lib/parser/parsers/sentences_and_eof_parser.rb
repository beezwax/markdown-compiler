require_relative "concerns/matches_star"

class SentencesAndEofParser < BaseParser
  include MatchesStar

  def match(tokens)
    nodes, consumed = match_star tokens, with: sentence_parser

    return Node.null if nodes.empty?
    if tokens.peek_at(consumed, 'EOF')
      consumed += 1
    elsif tokens.peek_at(consumed, 'NEWLINE', 'EOF')
      consumed += 2
    else
      return Node.null
    end

    ParagraphNode.new(sentences: nodes, consumed: consumed)
  end
end
