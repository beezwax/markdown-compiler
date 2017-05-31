# Writing a Markdown Compiler
Have you ever wanted to make your own programming language? Maybe a template
engine? Or a markdown parser? If you have ever built any of those, you might
have noticed it's not exactly easy to get started. There's a lot of concepts to
digest before you get going. That's why lots of devs just give up.

This series will show you how to make a compiler from scratch. The techniques
displayed here are the basis for the the topics stated above, and many more!

## What exactly is a compiler anyways?
Let's start from the beginning and define what a compiler is. A compiler is just
a black box which translates input in a given language to output in another
language. The input and output languages can be anything. If you've been in the
Javascript world for the past few years you might have seen something called
_transpiler_. A transpiler is actually a compiler, it transforms, for example,
_Coffeescript_ source code into _Javascript_ source code or _SASS_ into _CSS_.

It's important to note that compilers can't take any language as input, for
example, with the techniques showed here, you cannot write an
english-to-machine-code compiler. But for _simple_ languages, we can. Once we
get into parsing we'll learn more about those kind of languages, for now, just
know that every programming language you know can be an input language for a
compiler.

## What we'll build
To keep things simple, I decided to make a simple compiler which translates a
tiny subset of markdown to HTML. Here's an example:

    Markdown.to_html('_Foo_ **bar**') # => "<em>Foo<em> <strong>bar<strong>"

As you can see, we put in markdown, and get back HTML. For the implementation
language, I've chosen Ruby, a language we love at Beezwax. Because Ruby's focus
on readability and programmer happiness, I think it's a great choice for us, as
we don't care much about speed and optimizations, we just want the concepts in
the simplest possible way.

You'll learn about tokenization, parsing and code-generation. Because I'll talk
about compilers, I won't get into things like interpreters or optimizations. I
just want to give the reader a solid base, so they can get a taste of this whole
subject, and pursue their own more specific interests if they happen to like it.

Some of the things you might want to do afterwards are making your own
programming language, virtual machine, template engine, scripting language, DSL,
type checker, syntax checker, synax highlighter, smart code renaming,
autocomplete... The sky is the limit!

## Overview of our compiler
Our compiler, like most compilers, will consist of three steps. We'll dive deep
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

Next, we take those tokens and pass them into a parser. That parser will give us
a tree data-structure representing our tokens organized in certain way.

```
                                               +--------+
[UNDERSCORE, "Hello, World!", UNDERSCORE] +--> | PARSER | +--> #<EmphasisText "Hello, World!">
                                               +--------+
```

Finally, with our tree, we can generate the proper HTML:

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
