module Documents
  class SelectValue < FieldValue
    include OptionsConverter

    has_attribute :value, :string
    before_validation :convert_options_to_values, if: -> { options.any? }
    before_validation :set_default_value, if: -> { value.blank? && default_value.present? }
    before_validation :set_default_display_style, if: -> { display_style.blank? }
    validates :display_style, inclusion: {in: %w[select buttons]}
    validates :value, presence: {message: :required}, on: :update, if: -> { required? }
    validates :value, inclusion: {in: ->(record) { record.keys_from(record.option_values) }, message: :invalid_option}, on: :update, allow_blank: true
    validate :default_value_is_valid_option, if: -> { default_value.present? && option_values.any? }

    def to_s = value_from(option_values, key: value) || value.to_s
    def keys = keys_from(option_values)
    def values = values_from(option_values)
    def options_for_select = option_values.map { |v| [v.dig("value"), v.dig("key")] }
    def score = score_from(option_values, key: value)
    def colour = colour_from(option_values, key: value)

    private def convert_options_to_values
      self.option_values = convert_options(options)
      self.options = {}
    end

    private def set_default_value
      self.value = default_value
    end

    private def set_default_display_style
      self.display_style = "select"
    end

    private def default_value_is_valid_option
      errors.add :default_value, :invalid_default_option unless keys_from(option_values).include?(default_value)
    end
  end
end
