module Documents
  class NumberValue < FieldValue
    has_attribute :value, :integer
    validates :value, presence: true, numericality: {only_integer: true}, on: :update, if: -> { required? }
  end
end
