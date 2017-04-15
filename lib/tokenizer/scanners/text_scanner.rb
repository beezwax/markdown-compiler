require_relative '../tokens/token'

class TextScanner < SimpleScanner
  def self.from_string(plain_markdown)
    length = 0
    char   = plain_markdown[length]
    text   = ''
    until TOKEN_TYPES.key?(char) || char.blank?
      text   += char
      length += 1
      char    = plain_markdown[length]
    end

    Token.new(type: 'TEXT', value: text)
  end
end
