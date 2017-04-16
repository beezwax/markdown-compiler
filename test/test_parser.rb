require 'minitest/autorun'
require 'pry'

class TestParser < Minitest::Test
  def setup
    @tokenizer = Tokenizer.new
    @parser = Parser.new
  end

  def parse(markdown)
    @parser.parse(@tokenizer.tokenize(markdown))
  end

  def test_simple
    ast = parse('__Foo__ and text.')
    binding.pry
    assert_equal true, true
  end
end
