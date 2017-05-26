require_relative "base_parser"
require_relative "concerns/matches_first"

class SentenceParser < BaseParser
  include MatchesFirst

  def match(tokens)
    match_first tokens, emphasis_parser, bold_parser, text_parser
  end
end
