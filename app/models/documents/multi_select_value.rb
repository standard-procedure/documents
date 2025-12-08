module Documents
  class MultiSelectValue < FieldValue
    has_attribute :values, :json, default: []
    before_validation :set_default_value, if: -> { values.blank? && default_value.present? }
    validates :values, presence: {message: :required}, on: :update, if: -> { required? }
    validate :all_values_are_valid_options, if: -> { values.present? && options.any? }
    validate :default_value_contains_valid_options, if: -> { default_value.present? && options.any? }

    def to_s = Array.wrap(values).map { |key| options[key] || key }.join(", ")

    private def set_default_value
      self.values = Array.wrap(parse_default_value)
    end

    private def all_values_are_valid_options
      errors.add :values, :invalid_option if invalid_keys_in?(values)
    end

    private def default_value_contains_valid_options
      errors.add :default_value, :invalid_default_option if invalid_keys_in?(parse_default_value)
    end

    private def invalid_keys_in?(keys) = (Array.wrap(keys) - options.keys).any?

    private def parse_default_value
      JSON.parse(default_value.to_s)
    rescue JSON::ParserError
      [default_value]
    end
  end
end
