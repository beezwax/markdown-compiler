require_relative 'base_parser'

class SentenceParser < BaseParser
  def match(tokens)
    match_first tokens, emphasis_parser, bold_parser, text_parser
  end
end
