# The Tokenizer
Let's start implementing! If you want the source code for the whole project, you
can find it at <TODO: Public GitHub URL for the repo>.

A tokenizer is just a black box which takes an input text and returns a list of
tokens. Because we want to recognize just a part of markdown, let's start with
some examples of the things we will match:

```
A paragraph __with__ some *text*
```

Because we are only going to match paragaphs, emphasized text and bold text -- no links,
lists, quotes, etc -- it makes sense to have the following tokens: `UNDERSCORE`;
`TIMES`; `NEWLINE`; `TEXT` and `EOF`.

So, for example, for the input `_Hello*` our tokenizer should return
`[UNDERSCORE, TEXT="Hello",  TIMES]`. Note that the tokenizer is quite simple,
it doesn't care whether the syntax is valid or not, it just regognizes the
bulding blocks.

Let's start with a test to define what our Tokenizer should do. We'll use
[Minitest](https://github.com/seattlerb/minitest) for the specs.

Please note that I won't share the full code in the code snippets, they are just
to demonstrate a concept, see the <TODO: Github repo URL> for the full code.

```ruby
class TestTokenizer < Minitest::Test
  def setup
    @tokenizer = Tokenizer.new
  end

  def test_underscore
    tokens = @tokenizer.tokenize('_Foo_')

    assert_equal tokens.first.type, 'UNDERSCORE'
    assert_equal tokens.first.value, '_'

    assert_equal tokens.second.type, 'TEXT'
    assert_equal tokens.second.value, 'Foo'

    assert_equal tokens.third.type, 'UNDERSCORE'
    assert_equal tokens.third.value, '_'
  end
end
```

There are many ways to write tokenizers, some use regular expressions, others
prefer to do the comparison themselves. Our approach will be quite object oriented,
as we are using Ruby for our example.

The tests alredy gives us quite a lot of information about our API. We'll have
a `Tokenizer` object, which takes a markdown input string and returns a list
of `Token` objects, which have `type` and `value` attributes.

We'll use some `Scanner` objects to find tokens. Basically, we'll register scanners, each one knows what tokens to match. Then, we run all the scanners though the text,
and collect what they return. We'll stop when something could not be matched
or everything has been consumed.

```ruby
class Tokenizer
  TOKEN_SCANNERS = [
    SimpleScanner, # Recognizes simple one-char tokens like `_` and `*`
    TextScanner    # Recognizes everything but a simple token
  ].freeze

  def tokenize(plain_markdown)
    tokens_array = tokens_as_array(plain_markdown)
    TokenList.new(tokens_array)
  end  

  private

  def tokens_as_array(plain_markdown)
    if plain_markdown.nil? || plain_markdown == ''
      [Token.end_of_file]
    else
      token = scan_one_token(plain_markdown)
      [token] + tokens_as_array(plain_markdown[token.length..-1])
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
```

The method of interest here is `scan_one_token`. It takes a plain markdown string
and returns a single token, matching the first character of the input string.

To do so, it iterates though the scanners, and if the token matched is not null
-- meaning if it's valid -- it will return that token, otherwise, just keep
trying scanners. We fail if we consume the whole array and returned nothing.

The `tokens_as_array` method is a wrapper for our previous method, it'a a
recursive function which basically calls `scan_one_token` until it cannot
anymore because there's no more string to send, or the `scan_one_token` method
raised an error. This method also appends an end of file token which will be
used to mark the end of the token list.

The `TokenList` class itself is just a convenient wrapper arond a collection so
there's no much point to showing it here.

What's now left to show you are the scanners, here's the first one, it
matches single characters, can't get simpler than this!

```ruby
class SimpleScanner
  TOKEN_TYPES = {
    '_'  => 'UNDERSCORE',
    '*'  => 'TIMES',
    "\n" => 'NEWLINE'
  }.freeze

  def self.from_string(plain_markdown)
    char = plain_markdown[0]
    Token.new(type: TOKEN_TYPES[char], value: char)
  rescue InvalidTokenError
    Token.null
  end
end
```

As you can see, all the work is performed in the `from_string` method. All
scanners must implement this method. The method takes a plain markdown string
as input and returns a single token, using some logic to figure whether it
should match it or not. When matched, returns a valid token, otherwise, returns
a "null token".

> __NOTE__ Null objects are an object oriented pattern which is used to get rid
> of unwanted `if` and avoid possible nil reference errors. If you've never
> heard of this before, you might want to check out [this other blog post](https://blog.beezwax.net/2016/03/25/avoid-nil-checks-code-confidently-be-happy/)
which explains it.

Now onto the other scanner, `TextScanner`:

```ruby
class TextScanner < SimpleScanner
  def self.from_string(plain_markdown)
    text = plain_markdown
           .each_char
           .take_while { |char| !char.nil? && !TOKEN_TYPES.key?(char) }
           .join('')
    Token.new(type: 'TEXT', value: text)
  rescue InvalidTokenError
    Token.null
  end
end
```

As you can see, this method consumes several characters from the input string.
It basically matches whatever is not matched in the other scanner.

Finally, let's move to our `Token` object.

```ruby
class Token
  attr_reader :type, :value
  def initialize(type:, value:)
    @type = type
    @value = value
    raise InvalidTokenError if value.nil? || type.nil?
  end

  def self.null
    @@null_token ||= NullToken.new
  end

  def self.end_of_file
    Token.new(type: 'EOF', value: '')
  end

  def length
    value.length
  end

  def null?
    false
  end

  def to_s
    "<type: #{type}, value: #{value}>"
  end
end

class InvalidTokenError < RuntimeError; end
```

As you can see, the object is rather small it holds two attributes, `type` and
`value`. It also has some named constructors, `.null` which creates a `NullToken`
and `.end_of_file` which creates an EOF token, which is appended to every read
input string to mark the end of the sequence.
