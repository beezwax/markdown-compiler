require_relative '../tokens/token'
require_relative '../tokens/null_token'

# This class scans for a token based on a single character. If there are no
# matches, it will return a NullToken.
#
# Eg: SimpleToken.from_string("_foo") => #<Token type:'UNDERSCORE', value: '_'>
#     SimpleToken.from_string("foo")  => #<NullToken>
#
class SimpleScanner
  TOKEN_TYPES = {
    '_'  => 'UNDERSCORE',
    '*'  => 'TIMES',
    '('  => 'POPEN',
    ')'  => 'PCLOSE',
    '['  => 'BOPEN',
    ']'  => 'BCLOSE',
    "\n" => 'NEWLINE'
  }.freeze

  def self.from_string(plain_markdown)
    char = plain_markdown.first
    type = TOKEN_TYPES.fetch(char) { raise InvalidTokenTypeError }
    Token.new(type: type, value: char)
  rescue InvalidTokenTypeError
    NullToken.new
  end
end

class InvalidTokenTypeError < Exception; end
