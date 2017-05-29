require_relative "visitors/body_visitor"

class Generator
  def generate(ast)
    body_visitor.visit(ast)
  end

  private

  def body_visitor
    BodyVisitor.new
  end
end
