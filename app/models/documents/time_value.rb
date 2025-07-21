module Documents
  class TimeValue < FieldValue
    has_attribute :value, :datetime
    before_validation :set_default_value, if: -> { value.blank? && default_value.present? }
    validates :value, presence: true, on: :update, if: -> { required? }

    def to_s = value.present? ? I18n.l(value, format: :short) : ""

    private def set_default_value
      self.value = (default_value == "now") ? Time.current : Time.parse(default_value)
    end
  end
end
