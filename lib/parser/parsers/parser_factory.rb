require_relative "bold_parser"
require_relative "emphasis_parser"
require_relative "sentence_parser"
require_relative "text_parser"
require_relative "paragraph_parser"
require_relative "sentences_and_eof_parser"
require_relative "sentences_and_newline_parser"
require_relative "body_parser"

class ParserFactory
  PARSERS = {
    bold_parser:                  BoldParser,
    emphasis_parser:              EmphasisParser,
    text_parser:                  TextParser,
    sentence_parser:              SentenceParser,
    paragraph_parser:             ParagraphParser,
    sentences_and_eof_parser:     SentencesAndNewlineParser,
    sentences_and_newline_parser: SentencesAndEofParser,
    body_parser:                  BodyParser,
  }.freeze

  def self.build(name, *args, &block)
    parser = PARSERS.fetch(name.to_sym) { raise "Invalid parser name: #{name}" }
    cache[parser] = parser.new(*args, &block) if cache[parser].nil?
    cache[parser]
  end

  def self.cache
    @@cache ||= {}
  end
end
