require_relative 'scanners/simple_scanner'
require_relative 'scanners/text_scanner'
require_relative 'token_list'

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

  def tokenize(plain_markdown)
    tokens_array = tokenize_as_array(plain_markdown)
    TokenList.new(tokens_array)
  end

  private

  def tokenize_as_array(plain_markdown)
    if plain_markdown.nil? ||plain_markdown == ''
      []
    else
      token = scan_one_token(plain_markdown)
      [token] + tokenize_as_array(plain_markdown[token.length..-1])
    end
  end

  def scan_one_token(plain_markdown)
    TOKEN_SCANNERS.each do |scanner|
      token = scanner.from_string(plain_markdown)
      return token unless token.null?
    end
    raise "The scanners could not match the given input: #{plain_markdown}"
  end
end
