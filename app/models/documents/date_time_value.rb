module Documents
  class DateTimeValue < TimeValue
    has_attribute :value, :datetime
    def to_s = value.present? ? I18n.l(value.to_time, format: :long) : ""
  end
end
