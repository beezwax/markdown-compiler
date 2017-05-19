require_relative '../tokens/token'

# A simple text scanner, it basically selects everything the simple scanner
# does not.
#
class TextScanner < SimpleScanner
  def self.from_string(plain_markdown)
    text = plain_markdown
           .each_char
           .take_while { |char| SimpleScanner.from_string(char).null? }
           .join('')
    Token.new(type: 'TEXT', value: text)
  rescue InvalidTokenError
    Token.null
  end
end
