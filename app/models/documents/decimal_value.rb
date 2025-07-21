module Documents
  class DecimalValue < FieldValue
    has_attribute :value, :decimal
    before_validation :set_default_value, if: -> { value.blank? && default_value.present? }
    validates :value, presence: true, on: :update, if: -> { required? }
    validates :value, numericality: true, allow_blank: true

    def to_s = value.present? ? value.to_f.round(2) : ""

    private def set_default_value
      self.value = default_value.to_f
    end
  end
end
