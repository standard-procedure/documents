module Documents
  class CheckboxValue < FieldValue
    has_attribute :value, :boolean
    before_validation :set_default_value, if: -> { value.nil? && default_value.present? }
    validates :value, inclusion: {in: [true, false]}, on: :update, if: -> { required? }

    private def set_default_value
      self.value = DEFAULTS[default_value.to_s].nil? ? ActiveModel::Type::Boolean.new.cast(default_value) : DEFAULTS[default_value.to_s]
    end

    DEFAULTS = {"yes" => true, "y" => true, "no" => false, "n" => false}.freeze
  end
end
