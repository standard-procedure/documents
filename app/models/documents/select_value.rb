module Documents
  class SelectValue < FieldValue
    has_attribute :value, :string
    before_validation :set_default_value, if: -> { value.blank? && default_value.present? }
    before_validation :set_default_display_style, if: -> { display_style.blank? }
    validates :display_style, inclusion: {in: %w[select buttons]}
    validates :value, presence: {message: :required}, on: :update, if: -> { required? }
    validates :value, inclusion: {in: ->(record) { record.options.keys }, message: :invalid_option}, on: :update, allow_blank: true
    validate :default_value_is_valid_option, if: -> { default_value.present? && options.any? }

    def to_s = value.present? ? (options[value] || value) : ""

    def options_for_select = options.map { |k, v| [v, k] }

    def score = value.to_f

    private def set_default_value
      self.value = default_value
    end

    private def set_default_display_style
      self.display_style = "select"
    end

    private def default_value_is_valid_option
      errors.add :default_value, :invalid_default_option unless options.key?(default_value)
    end
  end
end
