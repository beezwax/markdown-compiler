class BodyNode
  attr_reader :paragraphs, :consumed
  def initialize(paragraphs:, consumed:)
    @paragraphs = paragraphs
    @consumed  = consumed
  end

  def present?
    true
  end

  def null?
    false
  end
end
