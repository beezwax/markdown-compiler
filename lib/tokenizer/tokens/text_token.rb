require_relative 'simple_token'

class TextToken < SimpleToken
  def self.from_string(plain_markdown)
    length = 0
    char   = plain_markdown[length]
    text   = ''
    until TOKEN_TYPES.key?(char) || char.blank?
      text   += char
      length += 1
      char    = plain_markdown[length]
    end

    TextToken.new(type: 'TEXT', value: text)
  end
end
