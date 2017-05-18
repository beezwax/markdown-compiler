# Introduction
This series intends to demythify compilers and smooth the steep learning curve
associated with all that matter. I intend to show that the core concepts are
quite simple, and every developer can understand them. What's more, the
concepts you'll learn are a quite nice addition to your developer toolbox, I've
had some pleasant surprises where I get to use them in places I never thought I
would.

Until not so long ago, if you wanted to write a compiler you had to dive into
several academy-oriented books, digest some 700-pages-long books in order to
even attempt writing your first compiler.

Nowadays, there are much better resources for beginners, this project intends to
be one of them. Compilers are big, complicated beasts, but they all boil down to
simple concepts. After years of development we now have a rather generic way of
writing compilers. It's not the only way, but it works, it's used in several
languages, and it's extensible.

## What is a compiler?
A compiler is just a black box which translates input in a given language to
output in another language. The input and output languages can be anything.
If you've been in the Javascript world for the past few years you might have
seen something called _transpiler_. A transpiler is actually a compiler,
it transforms, for example, _Coffeescript_ source code into _Javascript_ source
code or _SASS_ into _CSS_. There are lots of compilers out there in the real
world!

It's important to note that compilers can't take any language as input, for
example, with the techniques showed here, you cannot write an
english-to-machine-code compiler. But for simple languages, we can. Once
we get into parsing we'll learn more about those kind of languages, for now,
just know that every programming language you know can be an input language for
a compiler.

## What we'll build
To keep things simple, I decided to make a simple compiler which translates
a subset of markdown to HTML. For the implementation language, I've chosen Ruby,
a language we love at Beezwax. Because Ruby's focus on readability and programmer
happiness, I think it's a great choice for us, as we don't care much about speed
and optimizations, we just want the raw concepts in the simplest possible way.

You'll learn about tokenization, parsing and code-emitting. Because I'll talk
about compilers, I won't get into things like interpreters or optimizations. I
just want to give the reader a solid base, so they can get a taste of this whole
subject, and pursue their own more specific interests if they happen to like it.

The things you can do are limitless! Make your own programming language, Virtual
Machine, template engine, scripting language, type checker, syntax checker,
synax highlighter, smart code renaming or autocomplete... The sky is the limit!

## Overview of our compiler
Our compiler, like most compilers, will consist of three steps. Well dive deep
into each step later on, but for now, let's just take a quick look at the whole
process. The first step is transforming the input markdown string into a list of
tokens.

```
                        +-----------+
"_Hello, World!_"  +--> | TOKENIZER | +--> [UNDERSCORE, "Hello, World!", UNDERSCORE]
                        +-----------+
```

A token is just a name for the basic building blocks of our language. For
example an underscore, a times symbol, a new line or just some words. This will
make things easier for us later on.

move this to tokenizer.md ---v

The tokens themselves depends on our input language, so they are not written
in stone.

For example, in Ruby, we could tokenize `a = 12` as `[<Identifier a>, <Equals>, <Number 12>]`. It doesn't really make sense to tokenize it as `[<Identifier a>, <Equals>, <Number 1>, <Number 2>]`.

move this to tokenizer.md ---^

Next, we take those tokens and pass them into a parser. That parser will give
us an Abstract Syntax Tree, don't worry if you don't know what that is for now.
It's just an object representing our tokens organized in certain way.

```
                                               +--------+
[UNDERSCORE, "Hello, World!", UNDERSCORE] +--> | PARSER | +--> #<EmphasisText "Hello, World!">
                                               +--------+
```

Finally, with an AST, we can generate the proper HTML:

```
                                          +---------+
<EmphasisText value:"Hello, World!"> +--> | CODEGEN | +--> <em>Hello, World!</em>`
                                          +---------+
```

Overall, the process looks like this:

```
                 +-----------+                       +--------+                  +---------+
"_Hello!_" +-->  | TOKENIZER | +--> [tokens...] +--> | PARSER | +--> #<AST> +--> | CODEGEN | +--> <em>Hello!</em>
                 +-----------+                       +--------+                  +---------+
```

You might think this is all quite complicated, but it's actually the most
standard way of writing compilers. With this structure, we not only divide the
problem into smaller chunks so it's easier to reason about and test, we can
easily swap some parts around, for example, change the code generator to emit,
for example, RTF documents instead of HTML documents. We could also write a new
Tokenizer and Parser for a different language, and as long as the returned
Abstract Syntax Tree is in the same format, we can still generate proper HTML.

TODO: Talk about regular expressions not matching everything, and why we need
grammars. Eg: match `a^nba^n`.
