require 'minitest/autorun'
require 'pry'

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
