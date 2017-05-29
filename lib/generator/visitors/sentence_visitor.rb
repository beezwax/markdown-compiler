require_relative 'bold_visitor'
require_relative 'emphasis_visitor'
require_relative 'text_visitor'

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
