require_relative 'base_parser'

class ParagraphParser < BaseParser
  def is_match(tokens)
    try_sentences_and_newline(tokens) || try_sencences_and_eof(tokens)
  end

  private

  def try_sentences_and_newline(tokens)
    false
  end

  def try_sencences_and_eof(tokens)
    sentences = []
    consumed = 0

    while true
      parser = sentence_parser
      break unless parser.is_match(tokens.offset(consumed))
      sentences += [parser.node]
      consumed += parser.consumed
    end

    return false if sentences.empty?
    return false unless tokens.peek_at(consumed, 'EOF')
    consumed += 1 # Consume EOF

    @node = SentenceNode.new(sentences)
    @consumed = consumed
  end
end
