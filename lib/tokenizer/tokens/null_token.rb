# A "null token". Follows the Nullable Object Pattern.
#
class NullToken
  def null?
    true
  end

  def present?
    false
  end
end
