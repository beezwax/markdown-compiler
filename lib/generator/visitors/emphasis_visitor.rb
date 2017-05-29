class EmphasisVisitor
  def visit(node)
    "<em>#{node.value}</em>"
  end
end
