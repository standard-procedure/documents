module Documents
  class TextValue < FieldValue
    has_attribute :value, :string
    validates :value, presence: true, on: :update, if: -> { required? }
  end
end
