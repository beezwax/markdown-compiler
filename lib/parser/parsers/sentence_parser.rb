require_relative 'base_parser'

class SentenceParser < BaseParser
  def is_match(tokens)
    match_one tokens, emphasis_parser, bold_parser, text_parser
  end
end
