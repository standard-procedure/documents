module Documents
  class DataValue < FieldValue
    has_model :value
    has_attribute :data_class, :string, default: ""
    validates :value, presence: true, on: :update, if: -> { required? }
    validate :value_is_correct_class, if: -> { data_class.present? }, on: :update

    private def value_is_correct_class
      errors.add :value, :invalid_data_class if value.present? && !value.is_a?(data_class.constantize)
    end
  end
end
