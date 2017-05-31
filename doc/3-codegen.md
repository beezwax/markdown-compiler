# Writing a Markdown Compiler Part 3: Code Generation
Welcome to the final part of these series on writing a markdown compiler! If you
have made it this far, congratulations! The last step is quite simple in this
case, you'll have your very own markdown subset compiler in no time.

In case you haven't read the other parts yet, [here's part 1]() and [here's part
2]().

## Visitor Pattern
Now that we have our language represented in a tree data structure, we'll use
something called _Visitor Pattern_ to visit each node. I could point you to an
article explaining this pattern but it's not really worth, it's easier to just
see it in action.

The overall idea of our implementation is that each visitor will return some
valid HTML. Once we have visited the whole tree we'll join all of the visitor's
generated code into a full HTML translation of our markdown subset.

Not much theory in this one, let's just dive into the code!


    class Generator
      def generate(ast)
        body_visitor.visit(ast)
      end

      private

      def body_visitor
        BodyVisitor.new
      end
    end

As you can see, we start with the top-most node, the Body node. We instantiate
it's visitor and return it's result. Quite trivial so far. Let's peek at that
visitor:


    class BodyVisitor
      def visit(body_node)
        body_node.paragraphs.map do |paragraph|
          paragraph_visitor.visit(paragraph)
        end.join
      end

      private

      def paragraph_visitor
        @paragraph_visitor ||= ParagraphVisitor.new
      end
    end

Because `body_node` is just a collection of paragraphs, we visit all of them
using `map` and join the result together, so we end up with a concatenated
string. The `ParagraphVisitor` is a bit more interesting:


    class ParagraphVisitor
      def visit(paragraph_node)
        "<p>#{sentences_for(paragraph_node)}</p>"
      end

      private

      def sentences_for(paragraph_node)
        paragraph_node.sentences.map do |sentences|
          sentence_visitor.visit(sentences)
        end.join
      end

      def sentence_visitor
        @sentence_visitor ||= SentenceVisitor.new
      end
    end

We are doing basically the same thing, the only difference is that we finally
add in some HTML! Because paragraphs are surrounded by `p` tags we wrap whatever
it's inside with those tags. We defer the work of translating what's inside the
paragraph to the `SentenceVisitor`:

    class SentenceVisitor
      SENTENCE_VISITORS = {
        "BOLD"     => BoldVisitor,
        "EMPHASIS" => EmphasisVisitor,
        "TEXT"     => TextVisitor
      }.freeze

      def visit(node)
        visitor_for(node).visit(node)
      end

      private

      def visitor_for(node)
        SENTENCE_VISITORS.fetch(node.type).new { raise "Invalid sentence node type" }
      end
    end

Sentences are made of a bunch three diffeerent possible token combinations. In
this visitor we make sure to get a valid instance given `node.type`. The
remaining visitors are quite small so I'll just show them all together:

    class BoldVisitor
      def visit(node)
        "<strong>#{node.value}</strong>"
      end
    end

    class EmphasisVisitor
      def visit(node)
        "<em>#{node.value}</em>"
      end
    end

    class TextVisitor
      def visit(node)
        node.value
      end
    end

As you can see we have chosen to translate bold using `strong` tags and emphasis
using `em` tags. We could of course use `b` and `i` tags or basically whatever
we want.

And that's it! Take a look at the generator spec to get a glimpse at how
everything works:

    class TestGenerator < Minitest::Test
      def setup
        @tokenizer = Tokenizer.new
        @parser    = Parser.new
        @generator = Generator.new
      end

      def generate(markdown)
        tokens = @tokenizer.tokenize(markdown)
        ast    = @parser.parse(tokens)
        @generator.generate(ast)
      end

      def test_generates_html
        assert_equal generate("__Foo__ and *text*.\n\nAnother para."),
          "<p><strong>Foo</strong> and <em>text</em>.</p><p>Another para.</p>"
      end
    end

In that test, it's quite clear how everything works together, afterall all we
are doing is just function composition: `generate(parse(tokenize("my input")))`.

This is quite rough overall, we could make lots of improvements. For example, we
could add a new object - `Markdown`, to abstract some of these things away,
afterall, users of the API will prefer to just do `Markdown.to_html("_foo_")`,
as they don't care how it works.

    class Markdown
      # ...
      def self.to_html(input)
        @generator.generate(@parser.parse(@tokenizer.tokenize(input)))
      end
      # ...
    end

The cool thing about this is that you can write another generator for, say, XML,
or ODT just by making a new generator. You could also re-think a new syntax for
markdown, make a new parser and reuse the codegen layer to stll emit HTML.

It doesn't really matter if you dont understand __everything__ but having a
birds eye view of a compiler is quite helpful. Hopefully these series will serve
you as a solid base for any project requiring some of these skills, be it
personal or for work. Remember the full source code [is at GitHub](), feel free
to play around with it.
