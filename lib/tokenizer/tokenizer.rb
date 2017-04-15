require 'active_support/all'
require_relative 'scanners/simple_scanner'
require_relative 'scanners/text_scanner'

# A tokenizer, the purpose of this class is to transform a markdown string
# into a list of "tokens". In this case, each token has a type and a value.
#
# Example:
#   "_Hi!_" => [{type: UNDERSCORE, value: '_'}, {type: TEXT, value: 'Hi!'},
#               {type: UNDERSCORE, value: '_'}]
#
class Tokenizer
  TOKEN_SCANNERS = [
    SimpleScanner, # Recognizes simple one-char tokens like `_` and `*`
    TextScanner    # Recognizes everything but a simple token
  ].freeze

  def initialize; end

  def tokenize(plain_markdown)
    if plain_markdown.blank?
      []
    else
      token = scan_token(plain_markdown)
      [token] + tokenize(plain_markdown[token.length..-1])
    end
  end

  def scan_token(plain_markdown)
    TOKEN_SCANNERS.each do |scanner|
      token = scanner.from_string(plain_markdown)
      return token unless token.null?
    end
    raise "The scanners could not match the given input: #{plain_markdown}"
  end
end
