# Parsing
Parsing is basically making sense of a bunch of list of tokens. For example, if
we were to design a language where you can assign a variable like this:

```
foo = 1
```

We could say that assignment consist of some word, an equals sign, and a number.
The following are _invalid_ assignments:

```
foo = bar # expects a number on the right hand side of the equation
foo       # no equals, no number
foo =     # nothing here!
= foo     # nothing on the left hand side
```

You can see we only accept a small numbers of tokens sequences. The accepted
sequences must be carefully ordered in order to be valid. A common solution to
this problem, -- matching sequences of characters, are regular expressions. A
not-so-common solution is writing a Parser, implementing some grammar.

Turns out that the are things that grammars can match things which regular
expressions can't, and that's why we are using grammars here. If you want to
know why, see the footnote.

Now, let's introduce a little grammar theory in. Don't worry, I promise it won't
be that bad.

A _gramar_ is a set or rules which together define all possible character
sequences valid. For example, we can define a very simple language by accepting
only the following sequences: `ab`, `aabb` and `aaabbb`. Everything else is
invalid.

We call the set of all these sequences (`L = { 'ab', 'aabb', 'aaabbb' }`) a
_formal language_. Why `formal`? Well, grammars are not powerful enough to match
natural languages, like English or Spanish, but for a programming language  -- a
language which must not have ambiguity, they are just what we need.

> __NOTE__ If you really want to know why, I'm afraid I'll have to point you to [a pretty
academical PDF](http://www.eecs.harvard.edu/~shieber/Biblio/Papers/shieber85.pdf)
which explains it. You might need a refresher on [Regular
Languages](http://web.stanford.edu/class/archive/cs/cs103/cs103.1132/lectures/15/Small15.pdf).

Let me show you a simple grammar:

```
Assign = Identifier EQUALS Number
```

In the rule above, I want to match an Identifier, a token of type EQUALS, and a
Number. All sequences following that rule are valid assignments. What is an
`Identifier` and a `Number`? Well, let's define them:

```
Assign     = Identifier EQUALS Number
Identifier = WORD
Number     = NUMBER
```

As you can see, we've defined them using some building blocks called Terminals,
or in our case, Tokens. In our code, we'll tell the _WORD_ token to match
`[a-z]+` and the _NUMBER_ token will match just [0-9].

Now, our language look something like `L = { 'a = 1', 'foo = 5', 'somelongword = 9', ... }`. 
In theory, is has infinite elements. In reality we don't have infinite memory so
we won't be able to match ridiculously long words. We cannot really implement
this parser. But we can match a simiar, actually more useful one, we easily
change the rules of the grammar to make it finite, one way is adding in that no
word can be longer than 5 characters.

## A simple Markdown grammar
Let's define our tiny subset of markdown in a grammar.

```
Paragraph          := SentenceAndNewline
                    | SentenceAndEOF

SentenceAndNewline := Sentence+ NEWLINE NEWLINE

SentencesAndEOF    := Sentence+ NEWLINE EOF
                    | Sentence+ EOF

Sentence           := EmphasizedText
                    | BoldText
                    | Text

EmphasizedText     := UNDERSCORE BoldText UNDERSCORE

BoldText           := UNDERSCORE UNDERSCORE TEXT UNDERSCORE UNDERSCORE
                        | STAR STAR TEXT STAR STAR
```

As you can see, our tokens are pretty self-explanatory. If you remember from my
previous post, `TEXT` is a token which matches anything but another token,
basically. So it's some kind of _match-all_. 

Our starting rule is the first one, `Paragraph`. A Paragraph is basically a set
of sentences. 

In our markdown language, a `Sentence` is not really a sentence in the english
sense, where it's basically a bunch of words until a full stop. In our language,
`__Hello__.  World` and `Some text. Some more text. Yet more text.` are single,
valid sentences.

When defining grammars to implement the way we will, there is just one rule: No
left recursion. What's left recursion? This:

```
Foo = Foo "ab"
    | "ab"
```

Why? Because we'll write a Recursive Descent Parser, which means, each rule gets
it's own function, and `Foo` looks like this:

```
def foo
  if foo # infinite loop here
    do something
  else
    do something else
  end
end
```

We got an infinite loop! The good news is that whatever grammar can be written
with left recursion, [can be written as a different equivalent grammar without
left recursion](http://www.csd.uwo.ca/~moreno/CS447/Lectures/Syntax.html/node8.html).

## On Abstract Syntax Trees
Now, just some more theory before I let you go :) The whole point of the grammar
is to get an Abstract Syntax Tree representation -- or AST for short, of our
input. For example `hello __world__` would translate as:

```
                       [PARAGRAPH]
                           |
                           v
               +-------[SENTENCES] ---------+
               |             |              |
               v             v              v
          [TEXT="hello "] [BOLD="world"] [TEXT="."]
```


> __NOTE__ If you've never seen a tree data structure before, you might [want to
> check that out](https://en.wikipedia.org/wiki/Tree_(data_structure)).

Our parent node is PARAGRAPH. That node has a single child, SENTENCES, which in
turn has 3 children nodes, TEXT, BOLD and another TEXT. The starting rule in our
parser will be the top-most parent in our tree.

The thing about getting a tree out of a grammar is that we can remove ambiguity.
Consider the following grammar:

```
Start    = Binop
Binop    = Binop Operator Binop
         | Number
Operator = + | - | * | /
Number   = 0 | 1 | 2 | ... | 9
```

If we were to manually build an AST for `2 + 2 - 4`, we get

```
                 +------[START]------+
                 |          |        |
                 v          v        v
              [BINOP] [OPERATOR=-] [NUMBER=4]
                |
   +------------+----------+
   |            |          |
   v            v          v
[NUMBER=2] [OPERATOR=+] [NUMBER=2]
```

So as you can see, we end up matching `(2 + 2) - 4`. The problem, is that an
equally valid representation could be:

```
   +------[START]------+
   |          |        |
   v          v        v
[NUMBER=2] [OPERATOR=+] [BINOP]
                           |
   +------------+----------|
   |            |          |
   v            v          v
[NUMBER=2] [OPERATOR=-] [NUMBER=4]
```

So we end up with `2 + (2 - 4)`. We have two possible ASTs to choose from. We
only need one, but we want our programs to be deterministic, and always return
the same AST for the same input. Looks like we'll have to make some choices.

Luckly for us, because we only use non left-recursive grammars, our grammars
don't have ambiguity! Let's see how we would write this as a non left-recursive
grammar:

```
Start          = Binop
Binop          = Substraction
Substraction   = Adition "-" Binop
Adition        = Division "+" Binop
Division       = Multiplication "/" Binop
Multiplication = Number "*" Binop
Number         = 0 | 1 | 2 | ... | 9
```

As you can see, we explicitly set the order of the operations to be performed.
The order in this case is Multiplication, Division, Adition, Substraction, like
C. The generated AST will now always be the same.

## Implementation
Enough theory, let's implement it! The approach we'll take is creating an object
for each rule in the parser. That rule might as well call other objects,
including itself, in order to either accept or reject a sequence of tokens.

For example, the `TEXT` parser matches a single `TEXT` token. 

```
class TextParser < BaseParser
  def match(tokens)
    return Node.null unless tokens.peek('TEXT')
    Node.new(type: 'TEXT', value: tokens.first.value, consumed: 1)
  end
end
```

You can see we return a null node if we could not match something, otherwise,
we return a valid node. We call the result _node_ because we want to build an
abstract syntax tree. For example, the tree representation of:

## Nerdy footnote
Modern regex engines allow for things like positive lookaheads and references. 

Some people might think we are over complicating things, they just want to use a
regular expression to match things, it seems to work for our example right? But
regular expressions can't match all formal languages, this means formal
languages are more powerful than regular expressions. Wanna see why?

A formal language is a language defined by a grammar rules.

Try to match the regular expression `a^nba^n`, that is, match a the same times
you match b. Eg: `aba`, `aabaa` and `aaabaaa` are all valid, but `aaba`, `ba`, `a`
and `b` are all invalid.

We can easily make a rule for it:

```
Foo = aba
    | a Foo a
```

In this case, `a` and `b` are tokens representing themselves. The `|` means
_or_, it will try the rules in the defined order until it matches, stopping at
the first match.

The same as there are regular expression engines, there are parser generators,
which take a set of rules as an input and build a parser for you, which you can
use to accept or reject strings.

Because regular expressions are simpler and useful enough, every modern language
packs a regular expressions library, but few languages have parser generators,
as they cover a more specific problem.
