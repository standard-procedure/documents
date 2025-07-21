module Documents
  class DateValue < FieldValue
    has_attribute :value, :date
    before_validation :set_default_value, if: -> { value.blank? && default_value.present? }
    validates :value, presence: true, on: :update, if: -> { required? }

    private def set_default_value
      self.value = Date.parse(default_value)
    end
  end
end
