# The Tokenizer
Let's start implementing! If you want the source code for the whole project, you
can find it at <TODO: Public GitHub URL for the repo>.

The first step in our compiler process is _tokenizing_ - also called Lexical
Analisys. Tokenizing is basically making sense of a bunch of characters by
transforming them into Tokens. For example: `Hello_` could be transformed to
`[<TEXT=HELLO>, <UNDERSCORE>]`, an array of plain old Ruby objects.

Because we want to recognize just a part of markdown, let's start with
some examples of the things we will match:

```
A paragraph __with__ some *text*
```

As we are only going to match paragraphs, emphasized text and bold text — no
links, lists, quotes, etc — it makes sense to have only the following tokens:
`UNDERSCORE`; `STAR`; `NEWLINE`; `TEXT` and `EOF`.

So, for example, for the input `_Hello*` our tokenizer should return
`[<UNDERSCORE>, <TEXT="Hello">, <STAR>]`.

Let's start with a test which defines what our Tokenizer should do. We'll use
[Minitest](https://github.com/seattlerb/minitest) for the specs.

The full source code for the compiler lives in [GitHub](), you are encouraged to
clone it and play with it. The snippets displayed here won't give you the whole
picture of this particular compiler, they instead focus on explaining concepts
so you can write your own.

There is not a single way to write tokenizers. Each one is different, tailored
to it's specific needs. In this series I'll use a rather simple, object oriented
approach, as we are using Ruby for our implementation. Emphasis will be put on
readability and simplicity over speed and performance.

We'll build a `Tokenizer` object, which will take a markdown input string and
return a list of `Token` objects, which have `type` and `value` attributes.

We'll use some `Scanner` objects to find tokens. Basically, we'll register
scanners that each match specific tokens. Then we run the text through all the
scanners and collect what they return. We'll stop when something could not be
matched or everything has been consumed.

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

The method of interest here is `scan_one_token`. It takes a plain markdown
string and returns a single token, matching the first character of the input
string. To do so, it iterates though the scanners, and if the token matched is
not null — i.e., if it's valid — it will return that token. Otherwise, it will
keep trying scanners. We fail if we consume the whole array and return nothing.

The `tokens_as_array` method is a wrapper for our previous method. It's a
recursive function which basically calls `scan_one_token` until there's no more
string to send, or the `scan_one_token` method raised an error. This method also
appends an end-of-file token, which will be used to mark the end of the token
list.

The `TokenList` class itself is just a convenient wrapper around a collection, so
there's not much point showing it here. Same for `Token` — it's just a data
object with two attributes, `type` and `value`.

What's now left to show you are the scanners. Here's the first one, which
matches single characters — can't get simpler than this!

```ruby
class SimpleScanner
  TOKEN_TYPES = {
    '_'  => 'UNDERSCORE',
    '*'  => 'STAR',
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
scanners must implement this method. The method takes a plain markdown string as
input and returns a single token, using some logic to determine whether it should
match it or not. When matched, it returns a valid token. Otherwise, it returns a "null
token". Note that a token knows when it's invalid — in this case when either the
`type` or the `value` are empty — that's the `InvalidTokenError` we are catching.

> __NOTE__ Null objects are an object-oriented pattern which is used to get rid
> of unwanted `if` and avoid possible nil reference errors. If you've never
> heard of this before, you might want to check out [this other blog post](https://blog.beezwax.net/2016/03/25/avoid-nil-checks-code-confidently-be-happy/),
which explains it.

Now onto the other scanner, `TextScanner`. This one is a bit more complicated
but still quite simple:

```ruby
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
```

We take advantage of Ruby functional-style list processing to fetch as
many valid characters from the string as we can. We consider a character _valid_
when it's not matched by the `SimpleScanner`.

And that's the gist of the Tokenizer! If you want to play around with it you
should just `git clone git:/....` and play with it with your favorite editor.

Try running the tests with `rake test test/test_tokenizer.rb`. Try adding new
characters to be recognized, like `(`; `)`; `[`; `]`.

## You did it!
If you've followed along, congrats! You've taken the first step towards writing
a tiny compiler. For now, you can relax, pat yourself on the back and sip some
coffee. Next time, we'll talk about  _Parsing_. We'll learn about Grammars,
formal languages and Abstract Syntax Trees. Don't worry — they are not as
scary as they sound.
