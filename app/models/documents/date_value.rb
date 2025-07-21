module Documents
  class DateValue < FieldValue
    has_attribute :value, :date
    before_validation :set_default_value, if: -> { value.blank? && default_value.present? }
    validates :value, presence: true, on: :update, if: -> { required? }

    def to_s = value.present? ? I18n.l(value, format: :long) : ""

    private def set_default_value
      self.value = (default_value == "today") ? Date.current : Date.parse(default_value)
    end
  end
end
