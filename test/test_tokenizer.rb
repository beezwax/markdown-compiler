require 'minitest/autorun'
require 'active_support/core_ext/array'

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
