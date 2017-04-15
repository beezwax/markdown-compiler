require 'active_support'
require 'active_support/core_ext/object/blank'

# A tokenizer, the purpose of this class is to transform a markdown string
# into a list of "tokens". In this case, each token has a type and a value.
#
# Example:
#   "_Hi!_" => [{type: UNDERSCORE, value: '_'}, {type: TEXT, value: 'Hi!'}, {type: UNDERSCORE, value: '_'}]
#
class Tokenizer
  TOKENS = {
    '_'  => 'UNDERSCORE',
    '*'  => 'TIMES',
    '('  => 'POPEN',
    ')'  => 'PCLOSE',
    '['  => 'BOPEN',
    ']'  => 'BCLOSE',
    "\n" => 'NEWLINE'
  }.freeze
  DEFAULT_TOKEN_TYPE = 'TEXT'.freeze

  def initialize
  end

  def tokenize(plain_markdown)
    text_so_far = ''
    result = []

    plain_markdown.each_char do |char|
      token_type = TOKENS.fetch(char) { DEFAULT_TOKEN_TYPE }
      if token_type == DEFAULT_TOKEN_TYPE
        text_so_far += char
      else
        if text_so_far.present?
          result += [Token.new(type: DEFAULT_TOKEN_TYPE, value: text_so_far)]
          text_so_far = ''
        end
        result += [Token.new(type: token_type, value: char)]
      end
    end

    if text_so_far.present?
      result += [Token.new(type: DEFAULT_TOKEN_TYPE, value: text_so_far)]
      text_so_far = ''
    end

    result
  end
end
