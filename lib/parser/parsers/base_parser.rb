require_relative 'parser_factory'

class BaseParser
  private

  # We use some reflection to prettify the parser depedencies. Basically, from
  # calling a `foo_parser` method is the same as doing `ParserFactory.build('foo_parser')`.
  #
  def method_missing(name, *args, &block)
    raise ArgumentError.new("Method #{name} does not exist.") unless name.to_s.end_with?('_parser')
    ParserFactory.build(name, *args, &block)
  end
end
