module Documents
  class DateTimeValue < TimeValue
    def to_s = value.present? ? I18n.l(value.to_datetime, format: :long) : ""
  end
end
