module Documents
  class TimeValue < FieldValue
    has_attribute :value, :datetime
    before_validation :set_default_value, if: -> { value.blank? && default_value.present? }
    validates :value, presence: true, on: :update, if: -> { required? }

    def to_s = value.present? ? I18n.l(value.to_time, format: :short) : ""

    private def set_default_value
      self.value = Chronic.parse(default_value)
    end
  end
end
