# The Tokenizer
Let's start implementing! If you want the source code for the whole project, you
can find it at <TODO: Public GitHub URL for the repo>.

A tokenizer is just a black box which takes an input text and returns a list of
tokens. Because we want to recognize just a part of markdown, let's start with
some examples of the things we will match:

```
A paragraph __with__ some *text*
```

Becayse we are only going to match paragaphs, emphasized text and bold text -- no links,
lists or quotes -- it makes sense to have the following tokens: `UNDERSCORE`;
`TIMES`; `NEWLINE`; `TEXT` and `EOF`.

So, for example, for the input `_Hello*` our tokenizer should return
`[UNDERSCORE, TEXT="Hello",  TIMES]`. Note that the tokenizer is quite simple,
it doesn't care whether the syntax is valid or not, it just regognizes the
bulding blocks.

Let's start with a test to define what our Tokenizer should do. We'll use
[Minitest](https://github.com/seattlerb/minitest) for the specs.

Please note that I won't share the full code in the code snippets, they are just
to demonstrate a concept, see the <TODO: Github repo URL> for the full code.

```
class TestTokenizer < Minitest::Test
  def setup
    @tokenizer = Tokenizer.new
  end

  def test_simple
    tokens = @tokenizer.tokenize('Hi')
    assert_equal tokens.first.type, 'TEXT'
    assert_equal tokens.first.value, 'Hi'
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

Now that we have an idea of what we want our class to do, let's dive right in.
I've used a `Scanner` approach to finding tokens. Basically, we'll register
scanners, each scanner knows what tokens to find. Then, we run all scanners
though the text, and collect what they return. We'll stop when there's a failure
or everything has been consumed.

```
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
