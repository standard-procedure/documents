module Documents
  class YesNoValue < FieldValue
    has_attribute :value, :string
    before_validation :set_default_value, if: -> { value.nil? && default_value.present? }
    before_validation :convert_value, if: -> { value.present? }
    validates :value, presence: true, on: :update, if: -> { required? }
    validates :value, inclusion: {in: %w[y n]}, on: :update, if: -> { value.present? && !allows_na? }
    validates :value, inclusion: {in: %w[y n na]}, on: :update, if: -> { value.present? && allows_na? }

    def allows_na? = (configuration || {}).dig("allows_na") || false

    def invert_colours? = (configuration || {}).dig("invert_colours") || false

    def score = (value == "y") ? 1 : 0

    private def convert_value
      self.value = convert(value)
    end

    private def convert(new_value) = allows_na? ? convert_with_na(new_value.to_s.strip.downcase) : convert_without_na(new_value.to_s.strip.downcase)

    private def convert_with_na(new_value) = (new_value == "na") ? "na" : convert_without_na(new_value)

    private def convert_without_na(new_value) = %w[y n].include?(new_value) ? new_value : cast(new_value)
    private def cast(new_value) = ActiveModel::Type::Boolean.new.cast(new_value) ? "y" : "n"

    private def set_default_value
      self.value = convert(default_value)
    end
  end
end
