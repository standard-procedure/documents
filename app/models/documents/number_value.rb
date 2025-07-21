module Documents
  class NumberValue < FieldValue
    has_attribute :value, :integer
    before_validation :set_default_value, if: -> { value.blank? && default_value.present? }
    validates :value, presence: true, on: :update, if: -> { required? }
    validates :value, numericality: {only_integer: true}, allow_blank: true

    private def set_default_value
      self.value = default_value.to_i
    end
  end
end
