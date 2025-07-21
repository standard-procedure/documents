module Documents
  class TextValue < FieldValue
    has_attribute :value, :string
    before_validation :set_default_value, if: -> { value.blank? && default_value.present? }
    validates :value, presence: true, on: :update, if: -> { required? }

    private def set_default_value
      self.value = default_value
    end
  end
end
