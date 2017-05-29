class ParagraphNode
  attr_reader :sentences, :consumed
  def initialize(sentences:, consumed:)
    @sentences = sentences
    @consumed  = consumed
  end

  def present?
    true
  end

  def null?
    false
  end
end
