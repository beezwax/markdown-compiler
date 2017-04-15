require_relative '../tokens/token'

class TextScanner < SimpleScanner
  def self.from_string(plain_markdown)
    text = plain_markdown
      .each_char
      .take_while { |char| char.present? && !TOKEN_TYPES.key?(char) }
      .join('')
    Token.new(type: 'TEXT', value: text)
  end
end
