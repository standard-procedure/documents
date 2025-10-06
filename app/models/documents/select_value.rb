module Documents
  class SelectValue < FieldValue
    has_attribute :value, :string
    has_attribute :options, :json, default: {}
    before_validation :set_default_value, if: -> { value.blank? && default_value.present? }
    validates :value, presence: {message: :required}, on: :update, if: -> { required? }
    validates :value, inclusion: {in: ->(record) { record.options.values }, message: :invalid_option}, on: :update, allow_blank: true
    validate :default_value_is_valid_option, if: -> { default_value.present? && options.any? }

    def to_s = value.present? ? (options.key(value) || value) : ""

    def options_for_select = options.map { |k, v| [v, k] }

    private def set_default_value
      self.value = default_value
    end

    private def default_value_is_valid_option
      errors.add :default_value, :invalid_default_option unless options.key?(default_value)
    end
  end
end
