require_relative 'base_parser'

class ParagraphParser < BaseParser
  def is_match(tokens)
    try_sentences_and_newline(tokens) || try_sencences_and_eof(tokens)
  end

  private

  def try_sentences_and_newline(tokens)
    sentences, consumed = match_sentences(tokens)
    return false if sentences.empty?
    return false unless tokens.peek_at(consumed, 'NEWLINE', 'NEWLINE')
    consumed += 2 # consume newlines

    @node = SentenceNode.new(sentences)
    @consumed = consumed
  end

  def try_sencences_and_eof(tokens)
    sentences, consumed = match_sentences(tokens)

    return false if sentences.empty?
    if tokens.peek_at(consumed, 'EOF')
      consumed += 1
    elsif tokens.peek_at(consumed, 'NEWLINE', 'EOF')
      consumed += 2
    else
      return false
    end

    @node = SentenceNode.new(sentences)
    @consumed = consumed
  end

  def match_sentences(tokens)
    sentences = []
    consumed  = 0

    while true
      parser = sentence_parser
      break unless parser.is_match(tokens.offset(consumed))
      sentences += [parser.node]
      consumed += parser.consumed
    end

    [sentences, consumed]
  end
end
