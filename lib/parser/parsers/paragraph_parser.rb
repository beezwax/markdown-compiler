require_relative 'base_parser'

class ParagraphParser < BaseParser
  def is_match(tokens)
    match_one tokens, sentences_and_newline_parser, sentences_and_eof_parser
  end  
end
