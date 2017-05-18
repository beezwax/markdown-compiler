require_relative 'base_parser'

class ParagraphParser < BaseParser
  def match(tokens)
    match_first tokens, sentences_and_newline_parser, sentences_and_eof_parser
  end
end
