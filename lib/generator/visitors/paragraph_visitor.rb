require_relative "sentence_visitor"

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
